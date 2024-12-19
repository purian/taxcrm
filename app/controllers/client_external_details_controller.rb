class ClientExternalDetailsController < ApplicationController
  def index
    @client_external_details = ClientExternalDetail.all
  end

  def new
    @client_external_detail = ClientExternalDetail.new
  end

  def create
    if params[:file].present?
      begin
        required_headers = ['client_id', 'client_number', 'client_name', 'client_phone_number']
        csv_headers = CSV.read(params[:file].path, headers: true).headers
        
        missing_headers = required_headers - (csv_headers || [])
        if missing_headers.any?
          return redirect_to new_client_external_detail_path, 
            alert: "Missing required columns: #{missing_headers.join(', ')}"
        end

        success_count = 0
        failed_rows = []
        
        CSV.foreach(params[:file].path, headers: true).with_index(2) do |row, line_num|
          begin
            ClientExternalDetail.create!(
              client_id: row['client_id'],
              client_number: row['client_number'],
              client_name: row['client_name'],
              client_phone_number: row['client_phone_number'],
              data_owner: params[:data_owner]
            )
            success_count += 1
          rescue => e
            failed_rows << "Row #{line_num}: #{e.message}"
          end
        end

        if failed_rows.any?          
          redirect_to client_external_details_path, 
            alert: "Imported #{success_count} records. Failed to import #{failed_rows.size} records: #{failed_rows.join('; ')}"
        else
          redirect_to client_external_details_path, 
            notice: "Successfully imported #{success_count} records."
        end
      rescue CSV::MalformedCSVError => e
        redirect_to new_client_external_detail_path, alert: "Invalid CSV file: #{e.message}"
      rescue => e
        redirect_to new_client_external_detail_path, alert: "Error importing CSV: #{e.message}"
      end
    else
      redirect_to new_client_external_detail_path, alert: 'Please select a file to import.'
    end
  end

  def sync_all
    unsync_records = ClientExternalDetail.where(sync_at: nil)
    
    @email = 'benamram119@walla.com'
    @password = 'Guy1986!'
    auth_token = AuthenticationService.fetch_token(@email, @password)
    # Get authentication token from service      
    results = {
      saved: 0,
      skipped: 0,
      already_updated: 0,
      errors: 0
    }

    unsync_records.find_each.with_index(1) do |record, index|
      Rails.logger.info("Processing record #{index}/#{unsync_records.count}: Client #{record.client_number}")
      
      begin
        object_id, lead_status = fetch_object_id_and_status(record.client_number, auth_token)

        if object_id.nil? || lead_status.nil?
          Rails.logger.info("Skipping client #{record.client_number}: Object ID or lead status not found")
          results[:errors] += 1
          next
        end

        if lead_status != "חסר נייד"
          Rails.logger.info("Skipping client #{record.client_number}: Lead status is already '#{lead_status}'")
          results[:already_updated] += 1
          next
        end

        existing_comment = extract_comment(object_id, auth_token)
        
        if update_phone_number(object_id, record.client_phone_number, existing_comment, auth_token, record.data_owner)
          Rails.logger.info("Successfully updated client #{record.client_number}")
          results[:saved] += 1
          record.update(sync_at: Time.current)
        else
          Rails.logger.info("Failed to update phone number for client #{record.client_number}")
          results[:errors] += 1
        end
      rescue StandardError => e
        Rails.logger.error("Sync error for client #{record.client_number}: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n")) # Add stack trace for debugging
        results[:errors] += 1
      end
    end

    redirect_to client_external_details_path, 
      notice: "Sync completed: #{results[:saved]} updated, #{results[:skipped]} skipped, " \
              "#{results[:already_updated]} already updated, #{results[:errors]} errors"
  end

  private

  def fetch_object_id_and_status(client_number, session_token)
    uri = URI('https://api-1.mbapps.co.il/parse/classes/Accounts')
    response = make_api_request(uri, {
      where: { Number: client_number.to_i, IsAccount: false },
      keys: "objectId,LeadStatusId.Name",
      limit: 1
    }, session_token, method: :get)

    return nil, nil unless response.is_a?(Net::HTTPSuccess)
    
    data = JSON.parse(response.body)
    result = data.dig("results", 0)
    [result["objectId"], result.dig("LeadStatusId", "Name")]
  end

  def extract_comment(object_id, session_token)
    uri = URI('https://api-1.mbapps.co.il/parse/classes/Accounts')
    response = make_api_request(uri, {
      where: { objectId: object_id },
      keys: "Comment",
      limit: 1
    }, session_token, method: :get)

    return nil unless response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body).dig("results", 0, "Comment")
  end

  def update_phone_number(object_id, new_phone_number, existing_comment, session_token, data_owner)
    uri = URI("https://api-1.mbapps.co.il/parse/classes/Accounts/#{object_id}")
    updated_comment = existing_comment.to_s.strip.empty? ? "נייד דרך #{data_owner}" : "#{existing_comment} | נייד דרך #{data_owner}"

    response = make_api_request(uri, {
      PhoneNumber: new_phone_number,
      Comment: updated_comment,
      LeadStatusId: { 
        __type: "Pointer", 
        className: "LeadStatuses", 
        objectId: "3S6OxTzAhJ" 
      }
    }, session_token, method: :put)

    response.is_a?(Net::HTTPSuccess)
  end

  def make_api_request(uri, body_params, session_token, method: :post)
    headers = {
      'accept' => '*/*',
      'content-type' => 'text/plain',
      'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
    }

    body = body_params.merge({
      _method: method.to_s.upcase,
      _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
      _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
      _ClientVersion: "js1.10.1",
      _SessionToken: session_token
    }).to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, headers)
    request.body = body
    http.request(request)
  end
end 
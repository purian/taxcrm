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
    
    # This is where you'll add your sync logic later
    
    unsync_records.update_all(sync_at: Time.current)
    redirect_to client_external_details_path, notice: 'All records have been synchronized.'
  end
end 
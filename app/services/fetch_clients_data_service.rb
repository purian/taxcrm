require 'httparty'
require 'cgi'

class FetchClientsDataService
  BASE_URL = 'https://api-4.mbapps.co.il/parse/classes/Accounts'
  DETAIL_URL = 'https://api-1.mbapps.co.il/parse/classes/Accounts'
  HEADERS = {
    'accept' => '*/*',
    'accept-language' => 'en-US,en;q=0.9,he;q=0.8',
    'content-type' => 'text/plain',
    'dnt' => '1',
    'origin' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il',
    'referer' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il/',
    'sec-ch-ua' => '"Google Chrome";v="123", "Not:A-Brand";v="8", "Chromium";v="123"',
    'sec-ch-ua-mobile' => '?0',
    'sec-ch-ua-platform' => '"macOS"',
    'sec-fetch-dest' => 'empty',
    'sec-fetch-mode' => 'cors',
    'sec-fetch-site' => 'same-site',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
  }

  def initialize
    email = 'benamram119@walla.com'
    password = 'Gg198666'
    @token = AuthenticationService.fetch_token(email, password)
  end

  def call
    Rails.logger.info "Starting FetchClientsDataService at #{Time.now}"
    fetch_data
    fetch_and_update_client_details
    Rails.logger.info "Completed FetchClientsDataService at #{Time.now}"
  end

  private

  def fetch_data
    skip = 0
    loop do
      Rails.logger.info "Fetching clients data with skip=#{skip} at #{Time.now}"
      retries = 0
      begin
        response = HTTParty.post(BASE_URL, headers: request_headers, body: request_body(skip).to_json)
        results = response.parsed_response['results']
        break if results.empty?

        records = results.map { |record| prepare_record(record) }

        if records.any?
          Rails.logger.info "Saving #{records.size} clients to the database at #{Time.now}"
          Client.upsert_all(records, unique_by: :objectId)
          Rails.logger.info "Saved #{records.size} clients to the database at #{Time.now}"
        else
          Rails.logger.info "No clients found to save at #{Time.now}"
        end

        skip += 100
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        retries += 1
        if retries <= 10
          Rails.logger.warn "Attempt #{retries} failed: #{e.message}. Retrying in 2 seconds..."
          sleep 2
          retry
        else
          Rails.logger.error "Failed to fetch clients data after 10 attempts: #{e.message}"
          raise
        end
      end
    end
  end

  def fetch_and_update_client_details
    Client.find_each do |client|
      if client.last_details_scraped_at.nil? || client.updated_at > client.last_details_scraped_at
        Rails.logger.info "Fetching details for client #{client.objectId} at #{Time.now}"
        retries = 0
        begin
          response = HTTParty.post(DETAIL_URL, headers: request_headers, body: detail_request_body(client.objectId).to_json)
        
          if response.success? && response.parsed_response.is_a?(Hash)
            client_details = response.parsed_response['results']&.first
            if client_details
              Rails.logger.info "Updating client #{client.objectId} with new details at #{Time.now}"
              client.update(prepare_client_record(client_details))
            else
              Rails.logger.warn "No details found for client #{client.objectId} at #{Time.now}"
            end
          else
            Rails.logger.error "Failed to fetch details for client #{client.objectId}. Status: #{response.code}, Body: #{response.body}"
          end
        rescue Net::OpenTimeout, Net::ReadTimeout, SocketError => e
          retries += 1
          if retries <= 10
            Rails.logger.warn "Attempt #{retries} failed for client #{client.objectId}: #{e.message}. Retrying in 2 seconds..."
            sleep 2
            retry
          else
            Rails.logger.error "Failed to fetch details for client #{client.objectId} after 10 attempts: #{e.message}"
          end
        rescue StandardError => e
          Rails.logger.error "Unexpected error for client #{client.objectId}: #{e.class} - #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        end
      end
    end
  end

  def request_headers
    HEADERS.merge('X-Parse-Session-Token' => @token)
  end

  def request_body(skip)
    {
      where: { IsAccount: { "$ne": false } },
      keys: "Number2,Number,Name,CompanyId,PhoneNumber,Email,OwnerId.name,createdAt,LeadOwnerId.name,DateBecomeCustomer,objectId,Documentation,IsAccount",
      limit: 100,
      skip: skip,
      _method: "GET",
      _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
      _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
      _ClientVersion: "js1.10.1",
      _InstallationId: "05469a40-8496-73cb-2384-684469410ff2",
      _SessionToken: @token
    }
  end

  def detail_request_body(object_id)
    {
      where: { objectId: object_id },
      include: "LeadIrrelevantReason,FieldAgent,TaxType,LeadStatusId,Clientconfidentiality,LeadOwnerId,ChangingLead,Lawyers,ChangedLeadToClient,FamilyStatus,WorkStatus,YearOfSaleNew,AdditionalSellers,redemption,Futuresale,KidsUnder18,PropertyTypeSold,AccountIsHanicapped,accident,NeedPromotion,CAPStatus",
      limit: 1,
      _method: "GET",
      _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
      _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
      _ClientVersion: "js1.10.1",
      _InstallationId: "05469a40-8496-73cb-2384-684469410ff2",
      _SessionToken: @token
    }
  end

  def prepare_record(record)
    {
      objectId: record['objectId'],
      Name: decode_html_entities(record['Name']),
      Number2: record['Number2'],
      Number: record['Number'],
      CompanyId: decode_html_entities(record['CompanyId']),
      PhoneNumber: decode_html_entities(record['PhoneNumber']),
      Email: decode_html_entities(record['Email']),
      OwnerId_name: decode_html_entities(record.dig('OwnerId', 'name')),
      LeadOwnerId_name: decode_html_entities(record.dig('LeadOwnerId', 'name')),
      DateBecomeCustomer: record.dig('DateBecomeCustomer', 'iso'),
      Documentation: decode_html_entities(record['Documentation']),
      IsAccount: record['IsAccount'],
      created_at: DateTime.parse(record['createdAt']),
      updated_at: DateTime.parse(record['updatedAt'])
    }
  end

  def prepare_client_record(record)
    {
      Website: record['Website'],
      PhoneNumber2: record['PhoneNumber2'],
      Source: record.dig('Source', 'objectId'),
      OtherSource: record['OtherSource'],
      Fax: record['Fax'],
      Heirs: record['Heirs'],
      NumberOfHeirs: record['NumberOfHeirs'],
      Comment: record['Comment'],
      State: record['State'],
      City: record['City'],
      Address: record['Address'],
      StatusId: record.dig('StatusId', 'objectId'),
      FamilyStatus: record.dig('FamilyStatus', 'Name'),
      PropertyTypeSold: record.dig('PropertyTypeSold', 'Name'),
      SoldProperty6Years: record.dig('SoldProperty6Years', 'objectId'),
      Industry: record['Industry'],
      AdditionalAsset: record.dig('AdditionalAsset', 'objectId'),
      AdditionalSellers: record.dig('AdditionalSellers', 'Name'),
      WorkStatus: record.dig('WorkStatus', 'Name'),
      LeadStatusId: record.dig('LeadStatusId', 'objectId'),
      AccountIsHanicapped: record.dig('AccountIsHanicapped', 'Name'),
      TaxType: record.dig('TaxType', 'Name'),
      DocStatus: record.dig('DocStatus', 'objectId'),
      AddressOfSale: record['AddressOfSale'],
      AverageIncome: record['AverageIncome'],
      AverageIncomePartner: record['AverageIncomePartner'],
      DivorceYear: record['DivorceYear'],
      YearOfSale: record['YearOfSale'],
      LawyerComissionPayed: record['LawyerComissionPayed'],
      SpouseID: record['SpouseID'],
      Lawyers: record.dig('Lawyers', 'Name'),
      Rentpayment: record['Rentpayment'],
      NeedPromotion: record.dig('NeedPromotion', 'Name'),
      mizrhai: record['mizrhai'],
      Clalit: record['Clalit'],
      DiscountBank: record['DiscountBank'],
      migdal: record['migdal'],
      mortgage: record['mortgage'],
      last_details_scraped_at: Time.current
    }
  end

  def decode_html_entities(text)
    CGI.unescapeHTML(text.to_s) if text
  end
end
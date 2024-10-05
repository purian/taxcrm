require 'cgi' # Required for decoding HTML entities

class FetchSalesDataService
  BASE_URL = 'https://api-4.mbapps.co.il/parse/classes/Sales'
  SALE_DETAIL_URL = 'https://api-1.mbapps.co.il/parse/classes/Sales'
  ACCOUNTING_HEADERS_URL = 'https://api-1.mbapps.co.il/parse/classes/AccountingHeaders'
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
    @last_fetched_at = Sale.maximum(:updated_at) || Time.at(0)
    email = 'benamram119@walla.com'
    password = 'Gg198666'
    @token = AuthenticationService.fetch_token(email, password)
  end

  def call
    Rails.logger.info "Starting FetchSalesDataService at #{Time.now}"
    fetch_data
    fetch_and_update_sale_details
    fetch_and_update_accounting_headers
    Rails.logger.info "Completed FetchSalesDataService at #{Time.now}"
  end

  private

  def fetch_data
    skip = 0
    records = []
    loop do
      response = HTTParty.post(BASE_URL, headers: request_headers, body: request_body(skip).to_json)
      results = response.parsed_response['results']
      break if results.empty?

      results.each { |record| records << prepare_record(record) }
      skip += 100
      sleep 2
    end

    Sale.upsert_all(records, unique_by: :objectId) unless records.empty?
  end

  def fetch_and_update_sale_details
    Sale.find_each do |sale|
      Rails.logger.info "Fetching details for sale #{sale.objectId} at #{Time.now}"
      retries = 0
      begin
        response = HTTParty.post(SALE_DETAIL_URL, 
                                 headers: request_headers, 
                                 body: sale_detail_request_body(sale.objectId).to_json)
        
        sale_details = response.parsed_response['results'].first
        if sale_details
          Rails.logger.info "Updating sale #{sale.objectId} with new details at #{Time.now}"
          sale.update(prepare_sale_record(sale_details))
        else
          Rails.logger.warn "No details found for sale #{sale.objectId} at #{Time.now}"
        end
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        retries += 1
        if retries <= 10
          Rails.logger.warn "Attempt #{retries} failed for sale #{sale.objectId}: #{e.message}. Retrying in 2 seconds..."
          sleep 2
          retry
        else
          Rails.logger.error "Failed to fetch details for sale #{sale.objectId} after 10 attempts: #{e.message}"
        end
      end
    end
  end

  def fetch_and_update_accounting_headers
    Sale.find_each do |sale|
      Rails.logger.info "Fetching accounting headers for sale #{sale.objectId} at #{Time.now}"
      retries = 0
      begin
        response = HTTParty.post(ACCOUNTING_HEADERS_URL, 
                                 headers: request_headers, 
                                 body: accounting_headers_request_body(sale.objectId).to_json)
        
        process_accounting_headers(response, sale)
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        retries += 1
        if retries <= 10
          Rails.logger.warn "Attempt #{retries} failed for sale #{sale.objectId}: #{e.message}. Retrying in 2 seconds..."
          sleep 2
          retry
        else
          Rails.logger.error "Failed to fetch accounting headers for sale #{sale.objectId} after 10 attempts: #{e.message}"
        end
      end
    end
  end

  def request_headers
    HEADERS.merge('X-Parse-Session-Token' => @token)
  end

  def request_body(skip)
    {
      where: {},
      keys: "Name,AccNumber,AccountId.Name,AccountId.CompanyId,AccountId.PhoneNumber,SaleStatusId.Name,CAPStatus.Name,PraiseTax,BookkeepingDate,AccountId.IsAccount",
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

  def sale_detail_request_body(object_id)
    {
      where: { objectId: object_id },
      include: "Source,LeadOwnerId,WorkStatus,FamilyStatus,SoldProperty6Years,PropertyTypeSold,AdditionalSellers,AdditionalAsset,StatusId,DocStatus,Lawyers,LeadStatusId,ChangedLeadToClient",
      limit: 1,
      _method: "GET",
      _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
      _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
      _ClientVersion: "js1.10.1",
      _InstallationId: "05469a40-8496-73cb-2384-684469410ff2",
      _SessionToken: @token
    }
  end

  def accounting_headers_request_body(object_id)
    {
      where: { AccountId: { __type: "Pointer", className: "Accounts", objectId: object_id } },
      keys: "DocumentDate,DocumentNumber,DocTypeId.Name,Email,TotalSum,File,Name",
      limit: 100,
      order: "-DocumentDate",
      _method: "GET",
      _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
      _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
      _ClientVersion: "js1.10.1",
      _InstallationId: "9f63e5c7-8d7c-fa3b-24af-f910a1560651",
      _SessionToken: @token
    }
  end

  def process_accounting_headers(response, sale)
    headers = response['results']
    headers.each do |header|
      AccountingHeader.find_or_initialize_by(external_object_id: header['objectId']).tap do |ah|
        ah.update!(
          object_id: sale.objectId,
          object_type: 'Sale',
          document_date: parse_date(header['DocumentDate']),
          document_number: header['DocumentNumber'],
          doc_type_name: safe_dig(header, 'DocTypeId', 'Name'),
          name: header['Name'],
          total_sum: header['TotalSum'],
          email: header['Email'],
          file_name: safe_dig(header, 'File', 'name'),
          file_url: safe_dig(header, 'File', 'url'),
          file_private: safe_dig(header, 'File', 'private'),
          external_created_at: parse_date(header['createdAt']),
          external_updated_at: parse_date(header['updatedAt'])
        )
      end
    end
  end

  def parse_date(date_hash)
    DateTime.parse(date_hash['iso']) if date_hash
  end

  def decode_html_entities(value)
    CGI.unescapeHTML(value.to_s) unless value.nil?
  end

  def prepare_record(record)
    {
      objectId: record['objectId'],
      Name: decode_html_entities(record['Name']),
      AccNumber: decode_html_entities(record['AccNumber']),
      AccountId_Name: decode_html_entities(record.dig('AccountId', 'Name')),
      AccountId_CompanyId: decode_html_entities(record.dig('AccountId', 'CompanyId')),
      AccountId_PhoneNumber: decode_html_entities(record.dig('AccountId', 'PhoneNumber')),
      SaleStatusId_Name: decode_html_entities(record.dig('SaleStatusId', 'Name')),
      CAPStatus_Name: decode_html_entities(record.dig('CAPStatus', 'Name')),
      PraiseTax: record['PraiseTax'],
      PraiseTaxNumber: record['PraiseTax'].to_i,
      BookkeepingDate: parse_date(record['BookkeepingDate']),
      AccountId_IsAccount: record.dig('AccountId', 'IsAccount'),
      created_at: DateTime.parse(record['createdAt']),
      updated_at: DateTime.parse(record['updatedAt'])
    }
  end

  def prepare_sale_record(record)
    {
      Source: safe_dig(record, 'Source', 'objectId'),
      OtherSource: decode_html_entities(record['OtherSource']),
      LeadOwnerId_username: safe_dig(record, 'LeadOwnerId', 'username'),
      LeadOwnerId_name: safe_dig(record, 'LeadOwnerId', 'name'),
      LeadOwnerId_active: safe_dig(record, 'LeadOwnerId', 'active'),
      LeadOwnerId_job: safe_dig(record, 'LeadOwnerId', 'job'),
      LeadOwnerId_phone: safe_dig(record, 'LeadOwnerId', 'phone'),
      LeadOwnerId_extension: safe_dig(record, 'LeadOwnerId', 'extension'),
      LeadOwnerId_last_success_login: parse_date(safe_dig(record, 'LeadOwnerId', 'last_success_login')),
      Email: decode_html_entities(record['Email']),
      City: decode_html_entities(record['City']),
      Address: decode_html_entities(record['Address']),
      PhoneNumber2: decode_html_entities(record['PhoneNumber2']),
      Website: decode_html_entities(record['Website']),
      Fax: decode_html_entities(record['Fax']),
      WorkStatus_Name: safe_dig(record, 'WorkStatus', 'Name'),
      FamilyStatus_Name: safe_dig(record, 'FamilyStatus', 'Name'),
      SoldProperty6Years: safe_dig(record, 'SoldProperty6Years', 'objectId'),
      PropertyTypeSold_Name: safe_dig(record, 'PropertyTypeSold', 'Name'),
      AdditionalSellers_Name: safe_dig(record, 'AdditionalSellers', 'Name'),
      NumberOfHeirs: record['NumberOfHeirs'],
      AdditionalAsset: safe_dig(record, 'AdditionalAsset', 'objectId'),
      Comment: decode_html_entities(record['Comment']),
      Documentation: decode_html_entities(record['Documentation']),
      IsAccount: record['IsAccount'],
      updatedBy: safe_dig(record, 'updatedBy', 'objectId'),
      createdBy: safe_dig(record, 'createdBy', 'objectId'),
      Number: record['Number'],
      StatusId: safe_dig(record, 'StatusId', 'objectId'),
      DocStatus: safe_dig(record, 'DocStatus', 'objectId'),
      Number2: record['Number2'],
      Lawyers_Name: safe_dig(record, 'Lawyers', 'Name'),
      Lawyers_Address: safe_dig(record, 'Lawyers', 'Address'),
      Lawyers_OwnerId: safe_dig(record, 'Lawyers', 'OwnerId', 'objectId'),
      Lawyers_PhoneNumber: safe_dig(record, 'Lawyers', 'PhoneNumber'),
      Lawyers_Description: safe_dig(record, 'Lawyers', 'Description'),
      Lawyers_OfficePhone: safe_dig(record, 'Lawyers', 'OfficePhone'),
      Lawyers_Email: safe_dig(record, 'Lawyers', 'Email'),
      Lawyers_LinkingFactor: safe_dig(record, 'Lawyers', 'LinkingFactor'),
      Lawyers_Comment: safe_dig(record, 'Lawyers', 'Comment'),
      Lawyers_StatusLaw: safe_dig(record, 'Lawyers', 'StatusLaw', 'objectId'),
      LeadStatusId_Name: safe_dig(record, 'LeadStatusId', 'Name'),
      LeadStatusId_StateId: safe_dig(record, 'LeadStatusId', 'StateId', 'objectId'),
      DateBecomeCustomer: parse_date(record['DateBecomeCustomer']),
      ChangedLeadToClient_username: safe_dig(record, 'ChangedLeadToClient', 'username'),
      ChangedLeadToClient_email: safe_dig(record, 'ChangedLeadToClient', 'email'),
      ChangedLeadToClient_name: safe_dig(record, 'ChangedLeadToClient', 'name'),
      ChangedLeadToClient_active: safe_dig(record, 'ChangedLeadToClient', 'active'),
      ChangedLeadToClient_extension: safe_dig(record, 'ChangedLeadToClient', 'extension'),
      ChangedLeadToClient_job: safe_dig(record, 'ChangedLeadToClient', 'job'),
      ChangedLeadToClient_phone: safe_dig(record, 'ChangedLeadToClient', 'phone'),
      ChangedLeadToClient_last_success_login: parse_date(safe_dig(record, 'ChangedLeadToClient', 'last_success_login')),
      updatedByTrigger: decode_html_entities(record['updatedByTrigger']),
      last_details_scraped_at: Time.now
    }
  end

  def safe_dig(hash, *keys)
    keys.reduce(hash) do |acc, key|
      acc.is_a?(Hash) ? (acc[key] || acc[key.to_s]) : nil
    end
  end
end
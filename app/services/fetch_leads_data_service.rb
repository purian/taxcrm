# app/services/fetch_leads_data_service.rb
require 'httparty'
require 'cgi'

class FetchLeadsDataService
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
    fetch_data
    fetch_and_update_lead_details
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

    Lead.upsert_all(records, unique_by: :objectId) unless records.empty?
  end

  def fetch_and_update_lead_details
    Lead.find_each do |lead|
      response = HTTParty.post(DETAIL_URL, headers: request_headers, body: detail_request_body(lead.objectId).to_json)
      lead_details = response.parsed_response['results'].first

      lead.update(prepare_lead_record(lead_details))
    end
  end

  def request_headers
    HEADERS.merge('X-Parse-Session-Token' => @token)
  end

  def request_body(skip)
    {
      where: { IsAccount: false },
      keys: "createdAt,CompanyId,LeadStatusId.Name,Number,Documentation,SourceList,Name,Email,PhoneNumber,LeadOwnerId.name,PraiseTax,Lawyers.Name,IsAccount",
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
      include: "LeadIrrelevantReason,FieldAgent,TaxType,LeadStatusId,Clientconfidentiality,LeadOwnerId,ChangingLead,Lawyers,ChangedLeadToClient,FamilyStatus,WorkStatus,YearOfSaleNew,AdditionalSellers,redemption,Futuresale,KidsUnder18,AccountIsHanicapped,PropertyTypeSold,NeedPromotion,CAPStatus",
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
      Email: decode_html_entities(record['Email']),
      PhoneNumber: decode_html_entities(record['PhoneNumber']),
      CompanyId: decode_html_entities(record['CompanyId']),
      LeadStatusId_Name: decode_html_entities(record.dig('LeadStatusId', 'Name')),
      Number: record['Number'],
      Documentation: decode_html_entities(record['Documentation']),
      SourceList: decode_html_entities(record['SourceList']),
      LeadOwnerId_name: decode_html_entities(record.dig('LeadOwnerId', 'name')),
      PraiseTax: decode_html_entities(record['PraiseTax']),
      Lawyers_Name: decode_html_entities(record.dig('Lawyers', 'Name')),
      IsAccount: record['IsAccount'],
      created_at: DateTime.parse(record['createdAt']),
      updated_at: DateTime.parse(record['updatedAt'])
    }
  end

  def prepare_lead_record(record)
    {
      Email: record['Email'],
      Website: record['Website'],
      LeadOwnerId_objectId: record.dig('LeadOwnerId', 'objectId'),
      LeadOwnerId_username: record.dig('LeadOwnerId', 'username'),
      LeadOwnerId_active: record.dig('LeadOwnerId', 'active'),
      LeadOwnerId_job: record.dig('LeadOwnerId', 'job'),
      LeadOwnerId_phone: record.dig('LeadOwnerId', 'phone'),
      LeadOwnerId_extension: record.dig('LeadOwnerId', 'extension'),
      PhoneNumber2: record['PhoneNumber2'],
      Fax: record['Fax'],
      State: record['State'],
      City: record['City'],
      Address: record['Address'],
      Comment: record['Comment'],
      Documentation: record['Documentation'],
      Heirs: record['Heirs'],
      AcademicDetails: record['AcademicDetails'],
      AlimonyDetails: record['AlimonyDetails'],
      ArmyDischargeDetails: record['ArmyDischargeDetails'],
      DonationDetails: record['DonationDetails'],
      FamilyDisabilityDetails: record['FamilyDisabilityDetails'],
      HandicappedDetails: record['HandicappedDetails'],
      HospitalDetails: record['HospitalDetails'],
      ImmigrationCardDetails: record['ImmigrationCardDetails'],
      NotWorkingDetails: record['NotWorkingDetails'],
      PensionDepositDetails: record['PensionDepositDetails'],
      PensionDetails: record['PensionDetails'],
      ReservesDetails: record['ReservesDetails'],
      SecuritiesDetails: record['SecuritiesDetails'],
      UnemploymentFeeDetails: record['UnemploymentFeeDetails'],
      LeadStatusId_objectId: record.dig('LeadStatusId', 'objectId'),
      LeadStatusId_Name: record.dig('LeadStatusId', 'Name'),
      TaxType_objectId: record.dig('TaxType', 'objectId'),
      TaxType_Name: record.dig('TaxType', 'Name'),
      Number2: record['Number2'],
      Campaign: record['Campaign'],
      AddressOfSale: record['AddressOfSale'],
      AverageIncome: record['AverageIncome'],
      AverageIncomePartner: record['AverageIncomePartner'],
      DivorceYear: record['DivorceYear'],
      YearOfSale: record['YearOfSale'],
      SpouseID: record['SpouseID'],
      NextNote: record.dig('NextNote', 'iso')
    }
  end

  def decode_html_entities(text)
    CGI.unescapeHTML(text.to_s) if text
  end
end
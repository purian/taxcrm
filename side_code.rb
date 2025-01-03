require 'httparty'
require 'cgi'

# Define necessary constants
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

def fetch_and_update_lead_details(token)
    lead = Lead.find_by_objectId("dyIz1r434q")
    response = HTTParty.post(DETAIL_URL, headers: request_headers(token), body: detail_request_body(lead.objectId, token).to_json)
    lead_details = response.parsed_response['results'].first

    lead.update(prepare_lead_record(lead_details)) if lead_details  
end

def request_headers(token)
  HEADERS.merge('X-Parse-Session-Token' => token)
end

def detail_request_body(object_id, token)
  {
    where: { objectId: object_id },
    include: "LeadIrrelevantReason,FieldAgent,TaxType,LeadStatusId,Clientconfidentiality,LeadOwnerId,ChangingLead,Lawyers,ChangedLeadToClient,FamilyStatus,WorkStatus,YearOfSaleNew,AdditionalSellers,redemption,Futuresale,KidsUnder18,AccountIsHanicapped,PropertyTypeSold,NeedPromotion,CAPStatus",
    limit: 1,
    _method: "GET",
    _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
    _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
    _ClientVersion: "js1.10.1",
    _InstallationId: "05469a40-8496-73cb-2384-684469410ff2",
    _SessionToken: token
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

# Get the token using your authentication service
email = 'benamram119@walla.com'
password = 'Guy1986!'
token = AuthenticationService.fetch_token(email, password)

# Call the function to fetch and update lead details
fetch_and_update_lead_details(token)






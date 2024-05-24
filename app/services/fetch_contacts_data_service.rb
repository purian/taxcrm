require 'httparty'

class FetchContactsDataService
BASE_URL = 'https://api-4.mbapps.co.il/parse/classes/Contacts'
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
  @last_fetched_at = Contact.maximum(:updated_at) || Time.at(0)
end

def call
  fetch_data
end

private

def fetch_data
  skip = 0
  loop do
    response = HTTParty.post(BASE_URL, headers: HEADERS, body: request_body(skip).to_json)
    results = response.parsed_response['results']
    break if results.empty?

    results.each { |record| save_record(record) }
    skip += 100
    sleep 2
  end
end

def request_body(skip)
  {
    where: { updatedAt: { "$gt": @last_fetched_at.iso8601 } },
    keys: "Name,Email,PhoneNumber,CellPhone,Position,AccountId.Name,OwnerId.name,AccountId.IsAccount",
    limit: 100,
    skip: skip,
    _method: "GET",
    _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
    _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
    _ClientVersion: "js1.10.1",
    _InstallationId: "05469a40-8496-73cb-2384-684469410ff2",
    _SessionToken: "r:a66173fe8b7b9916801b9253e07fafab"
  }
end

def save_record(record)
  Contact.create!(
    objectId: record['objectId'],
    Name: record['Name'],
    Email: record['Email'],
    PhoneNumber: record['PhoneNumber'],
    CellPhone: record['CellPhone'],
    Position: record['Position'],
    AccountId_Name: record.dig('AccountId', 'Name'),
    OwnerId_name: record.dig('OwnerId', 'name'),
    AccountId_IsAccount: record.dig('AccountId', 'IsAccount')
  )
end
end
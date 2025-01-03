require 'httparty'
require 'cgi'

class FetchReferralsDataService
  BASE_URL = 'https://api-4.mbapps.co.il/parse/classes/Lawyers'
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
    @last_fetched_at = Referral.maximum(:updated_at) || Time.at(0)
    email = 'benamram119@walla.com'
    password = 'Guy1986!'
    @token = AuthenticationService.fetch_token(email, password)
  end

  def call
    fetch_data
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

    Referral.upsert_all(records, unique_by: :objectId) unless records.empty?
  end

  def request_headers
    HEADERS.merge('X-Parse-Session-Token' => @token)
  end

  def request_body(skip)
    {
      where: { IsAccount: { "$ne": false } },
      keys: "Name,PhoneNumber,OwnerId.name,City.Name,StatusLaw.Name,LinkingFactor",
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

  def prepare_record(record)
    {
      objectId: record['objectId'],
      Name: decode_html_entities(record['Name']),
      PhoneNumber: decode_html_entities(record['PhoneNumber']),
      OwnerId_name: decode_html_entities(record.dig('OwnerId', 'name')),
      City_Name: decode_html_entities(record.dig('City', 'Name')),
      StatusLaw_Name: decode_html_entities(record.dig('StatusLaw', 'Name')),
      LinkingFactor: decode_html_entities(record['LinkingFactor']),
      created_at: DateTime.parse(record['createdAt']),
      updated_at: DateTime.parse(record['updatedAt'])
    }
  end

  def decode_html_entities(text)
    CGI.unescapeHTML(text) if text
  end
end
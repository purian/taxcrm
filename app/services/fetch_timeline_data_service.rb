require 'httparty'
require 'json'

class FetchTimelineDataService
  TIMELINE_URL = 'https://api-1.mbapps.co.il/parse/classes/_Timeline'
  HEADERS = {
    'accept' => '*/*',
    'accept-language' => 'en-US,en;q=0.9,he;q=0.8',
    'content-type' => 'text/plain',
    'dnt' => '1',
    'origin' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il',
    'priority' => 'u=1, i',
    'referer' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il/apps/mybusiness/Timeline',
    'sec-ch-ua' => '"Chromium";v="128", "Not;A=Brand";v="24", "Google Chrome";v="128"',
    'sec-ch-ua-mobile' => '?0',
    'sec-ch-ua-platform' => '"macOS"',
    'sec-fetch-dest' => 'empty',
    'sec-fetch-mode' => 'cors',
    'sec-fetch-site' => 'same-site',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  }

  def initialize(email, password)
    @email = email
    @password = password
    @token = nil
  end

  def fetch_timeline(object_id)
    ensure_token
    Rails.logger.debug "Fetching timeline for object ID: #{object_id}"
    
    body = request_body(object_id)
    Rails.logger.debug "Request URL: #{TIMELINE_URL}"
    Rails.logger.debug "Request headers: #{HEADERS}"
    Rails.logger.debug "Request body: #{body}"
    
    response = HTTParty.post(
      TIMELINE_URL,
      headers: HEADERS,
      body: body
    )

    Rails.logger.debug "Response status: #{response.code}"
    Rails.logger.debug "Response body: #{response.body}"

    if response.success?
      results = response.parsed_response['results']
      Rails.logger.debug "Number of timeline items: #{results.size}"
      process_timeline_data(results)
    else
      Rails.logger.error "Failed to fetch timeline. Status: #{response.code}, Body: #{response.body}"
      []
    end
  end

  private

  def ensure_token
    @token ||= AuthenticationService.fetch_token(@email, @password)
  end

  def request_body(object_id)
    body = JSON.parse('{"where":{"AccountId":{"__type":"Pointer","className":"Accounts","objectId":"dyIz1r434q"},"$or":[{"Pinned":true},{"Last":true}]},"include":"user,user,NotePrivateFile,NotePrivateFile,user,ActivityI,user,ActivityId,ActivityTypeId,AccountId,AccountId,user,EmailI,user,AccountId,AccountId,user,PriceQuoteI,PriceQuoteStatusId,user,AccountId,AccountId,user,SMSI,user,AccountId,AccountId,user,CaseId,user,CaseId,CaseTypeId,CasePriorityId,CaseStatusId,AccountId,AccountId,user,AccountId,user,AccountId,AccountId,AccountId,user,ContactId,user,ContactId,AccountId,AccountId,user,TaskId,user,TaskId,TaskTypeId,AccountId,AccountId,user,SaleId,user,SaleId,SaleId,SaleStatusId,AccountId,AccountId","limit":10,"order":"-Pinned,-createdAt","_method":"GET","_ApplicationId":"aaaaaaae3aac375841ec08b905439c3fa4316c3d","_JavaScriptKey":"6ee213f7b4e169caa819715ee046cded","_ClientVersion":"js1.10.1","_InstallationId":"9f63e5c7-8d7c-fa3b-24af-f910a1560651","_SessionToken":"r:123689224f1e86b74f353526b2ce4b58"}')
    body['where']['AccountId']['objectId'] = object_id
    body['_SessionToken'] = @token
    body.to_json
  end

  def process_timeline_data(results)
    Rails.logger.debug "Processing #{results.size} timeline items"
    results.map do |result|
      Rails.logger.debug "Processing timeline item: #{result['objectId']}"
      {
        objectId: result['objectId'],
        event: result['event'],
        object_class: result['objectClass'],
        object_id_value: result['objectIdValue'],
        data: result['data'],
        pinned: result['Pinned'],
        last: result['Last'],
        created_at: result['createdAt'],
        updated_at: result['updatedAt'],
        sale_total: result['SaleTotal'],
        sale_name: result['SaleName'],
        sale_status_id: result.dig('SaleStatusId', 'objectId'),
        account_id: result.dig('AccountId', 'objectId'),
        sale_owner_id: result.dig('SaleOwner', 'objectId'),
        sale_id: result.dig('SaleId', 'objectId'),
        user_id: result.dig('user', 'objectId'),
        account_name: result.dig('AccountId', 'Name')
      }
    end
  end
end
require 'net/http'
require 'uri'
require 'json'

class CrmSyncService
  def initialize(session_token = nil)
    email = 'benamram119@walla.com'
    password = 'Guy1986!'
    @token = AuthenticationService.fetch_token(email, password)    
  end

  def sync_detail(detail)
    uri = URI.parse("https://api-1.mbapps.co.il/parse/classes/Accounts/#{detail.object_id}")
    
    request = Net::HTTP::Put.new(uri)
    set_headers(request)
    
    request.body = JSON.dump({
      "PhoneNumber" => detail.phone_number,
      "LeadStatusId" => {
        "__type" => "Pointer",
        "className" => "LeadStatuses",
        "objectId" => "3S6OxTzAhJ"
      },
      "Clientconfidentiality" => {
        "__type" => "Pointer",
        "className" => "YesNoList",
        "objectId" => "dymPdSn2J0"
      },
      "Comment" => "עידכון מספר טלפון: #{detail.comment}",
      "_method" => "PUT",
      "_ApplicationId" => "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
      "_JavaScriptKey" => "6ee213f7b4e169caa819715ee046cded",
      "_ClientVersion" => "js1.10.1",
      "_InstallationId" => "9f63e5c7-8d7c-fa3b-24af-f910a1560651",
      "_SessionToken" => @token
    })

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    case response
    when Net::HTTPSuccess
      true
    else
      Rails.logger.error "Failed to sync detail #{detail.id}: #{response.body}"
      false
    end
  rescue StandardError => e
    Rails.logger.error "Error syncing detail #{detail.id}: #{e.message}"
    false
  end

  private

  def set_headers(request)
    request["accept"] = "*/*"
    request["accept-language"] = "en-US,en;q=0.9,he;q=0.8"
    request["content-type"] = "application/json"
    request["origin"] = "https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il"
    request["referer"] = "https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il/apps/mybusiness/Account"
    request["user-agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
  end

end

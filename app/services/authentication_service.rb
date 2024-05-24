require 'httparty'
require 'nokogiri'

class AuthenticationService
  LOGIN_URL = 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il/loginToParse'
  HEADERS = {
    'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
    'accept-language' => 'en-US,en;q=0.9,he;q=0.8',
    'content-type' => 'application/x-www-form-urlencoded',
    'dnt' => '1',
    'origin' => 'null',
    'sec-ch-ua' => '"Google Chrome";v="123", "Not:A-Brand";v="8", "Chromium";v="123"',
    'sec-ch-ua-mobile' => '?0',
    'sec-ch-ua-platform' => '"macOS"',
    'sec-fetch-dest' => 'document',
    'sec-fetch-mode' => 'navigate',
    'sec-fetch-site' => 'cross-site',
    'sec-fetch-user' => '?1',
    'upgrade-insecure-requests' => '1',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
  }
  PAYLOAD = {
    'username' => 'benamram119%40walla.com',
    'encrypt_password' => 'YEfTyVbez8yZax7loL4njuLubHtUK%2B%2BoUYQ%2BQI%2BWOp8%3D',
    'encrypt__id' => '6650cf6b3c596ba667ed4c2f',
    'isAdmin' => true,
    'applicationId' => '5a8ebcecca2341001a722188',
    'requestFromDiffDomain' => 1
  }

  def self.fetch_token
    response = HTTParty.post(LOGIN_URL, headers: HEADERS, body: PAYLOAD)
    document = Nokogiri::HTML(response.body)
    script_content = document.at('script:contains("Simbla.User.become")').text
    token = script_content.match(/Simbla\.User\.become\("([^"]+)"\)/)[1]
    token
  end
end
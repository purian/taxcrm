require 'httparty'

class PublicKeyService
  PUBLIC_KEY_URL = 'https://api.mbapps.co.il/key'
  HEADERS = {
    'accept' => '*/*',
    'accept-language' => 'en-US,en;q=0.9,he;q=0.8',
    'dnt' => '1',
    'origin' => 'https://sub.mybusiness.co.il',
    'sec-ch-ua' => '"Google Chrome";v="123", "Not:A-Brand";v="8", "Chromium";v="123"',
    'sec-ch-ua-mobile' => '?0',
    'sec-ch-ua-platform' => '"macOS"',
    'sec-fetch-dest' => 'empty',
    'sec-fetch-mode' => 'cors',
    'sec-fetch-site' => 'cross-site',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
  }

  def self.fetch_public_key
    response = HTTParty.get(PUBLIC_KEY_URL, headers: HEADERS)
    public_key_data = JSON.parse(response.body)
    { public_key: public_key_data['publicKey'], id: public_key_data['_id'] }
  end
end
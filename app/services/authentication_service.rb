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
  def self.fetch_token(email, password)
    retries = 0
    begin
      public_key_data = PublicKeyService.fetch_public_key
      encrypted_password = EncryptionService.encrypt_password(password, public_key_data[:public_key])
      response = HTTParty.post(LOGIN_URL, headers: HEADERS, body: {
        username: email,
        encrypt_password: encrypted_password,
        encrypt__id: public_key_data[:id],
        isAdmin: true,
        applicationId: '5a8ebcecca2341001a722188',
        requestFromDiffDomain: 1
      }.to_query)
      
      document = Nokogiri::HTML(response.body)
      script_element = document.at('script:contains("Simbla.User.become")')
      
      if script_element.nil?
        puts "Failed to find authentication token. Retrying in 30 minutes..."
        30.times do |i|
          minutes_left = 30 - i
          puts "#{minutes_left} minutes remaining until next retry..."
          sleep 60
        end
        retries += 1
        retry
      end

      script_content = script_element.text
      token = script_content.match(/Simbla\.User\.become\("([^"]+)"\)/)[1]
      token
    rescue StandardError => e
      puts "Error occurred: #{e.message}"
      if retries < 3
        puts "Retrying in 30 minutes..."
        30.times do |i|
          minutes_left = 30 - i
          puts "#{minutes_left} minutes remaining until next retry..."
          sleep 60
        end
        retries += 1
        retry
      else
        raise "Failed to fetch authentication token after 3 retries"
      end
    end
  end
end
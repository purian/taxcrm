require 'csv'
require 'net/http'
require 'json'

# Function to fetch the object_id and status using client_number
def fetch_object_id_and_status(client_number)
  uri = URI('https://api-1.mbapps.co.il/parse/classes/Accounts')
  headers = {
    'accept' => '*/*',
    'content-type' => 'text/plain',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
  }

  body = {
    "where": { "Number": client_number, "IsAccount": false },
    "keys": "objectId,LeadStatusId.Name",
    "limit": 1,
    "_method": "GET",
    "_ApplicationId": "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
    "_JavaScriptKey": "6ee213f7b4e169caa819715ee046cded",
    "_ClientVersion": "js1.10.1",
    "_SessionToken": "r:f4cd1397abe6385aab072f9bf4c057d0"
  }.to_json

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri.path, headers)
  request.body = body

  response = http.request(request)

  if response.is_a?(Net::HTTPSuccess)
    data = JSON.parse(response.body)
    result = data.dig("results", 0)
    return result["objectId"], result.dig("LeadStatusId", "Name")
  else
    puts "Error fetching objectId and status: #{response.code} - #{response.message}"
    return nil, nil
  end
end

# Function to extract the comment using object_id
def extract_comment(object_id)
  uri = URI('https://api-1.mbapps.co.il/parse/classes/Accounts')
  headers = {
    'accept' => '*/*',
    'content-type' => 'text/plain',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
  }

  body = {
    "where": { "objectId": object_id },
    "keys": "Comment",
    "limit": 1,
    "_method": "GET",
    "_ApplicationId": "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
    "_JavaScriptKey": "6ee213f7b4e169caa819715ee046cded",
    "_ClientVersion": "js1.10.1",
    "_SessionToken": "r:f4cd1397abe6385aab072f9bf4c057d0"
  }.to_json

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri.path, headers)
  request.body = body

  response = http.request(request)

  return JSON.parse(response.body).dig("results", 0, "Comment") if response.is_a?(Net::HTTPSuccess)

  puts "Error fetching comment: #{response.code} - #{response.message}"
  nil
end

# Function to update the phone number, comment, and status
def update_phone_number(object_id, new_phone_number, existing_comment)
  uri = URI("https://api-1.mbapps.co.il/parse/classes/Accounts/#{object_id}")
  headers = {
    'accept' => '*/*',
    'content-type' => 'text/plain',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36'
  }

  updated_comment = existing_comment.to_s.strip.empty? ? "נייד דרך אלעד" : "#{existing_comment} | נייד דרך אלעד"

  body = {
    "PhoneNumber" => new_phone_number,
    "Comment" => updated_comment,
    "LeadStatusId" => { "__type" => "Pointer", "className" => "LeadStatuses", "objectId" => "3S6OxTzAhJ" },
    "_method" => "PUT",
    "_ApplicationId" => "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
    "_JavaScriptKey" => "6ee213f7b4e169caa819715ee046cded",
    "_ClientVersion" => "js1.10.1",
    "_SessionToken" => "r:f4cd1397abe6385aab072f9bf4c057d0"
  }.to_json

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri.path, headers)
  request.body = body

  response = http.request(request)

  return true if response.is_a?(Net::HTTPSuccess)

  puts "Error updating: #{response.code} - #{response.message}"
  false
end

# Main script
saved_records = 0
skipped_records = 0
already_updated_records = 0
error_records = 0

CSV.foreach('tax_phone_numbers_merged.csv', headers: true, encoding: 'UTF-8') do |row|
  client_number = row['client_number'].to_i
  new_phone_number = row['phone_number'].to_s.strip
  puts "Updating #{client_number} with Number: #{new_phone_number} ..."
  if new_phone_number.empty?
    skipped_records += 1
    puts "Skip, No Phone Number."
    next
  end

  begin
    object_id, lead_status = fetch_object_id_and_status(client_number)

    if object_id.nil? || lead_status.nil?
      error_records += 1
      puts "Error in objectId or status!"
      next
    end

    if lead_status != "חסר נייד"
      already_updated_records += 1
      puts "Already update!"
      next
    end

    existing_comment = extract_comment(object_id)    

    if update_phone_number(object_id, new_phone_number, existing_comment)
      saved_records += 1
      puts "Updated!"
    else
      error_records += 1
      puts "Error!"
    end
  rescue => e
    puts "Exception occurred: #{e.message}"
    error_records += 1
  end
end

puts "Process completed."
puts "Saved records: #{saved_records}"
puts "Skipped records (no phone): #{skipped_records}"
puts "Already updated records: #{already_updated_records}"
puts "Error records: #{error_records}"



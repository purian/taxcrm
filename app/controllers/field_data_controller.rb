# app/controllers/field_data_controller.rb
class FieldDataController < ApplicationController
  layout false
  def new
    # Renders a form for inputting base64 content
  end
  def decode    
    base64_content = params[:encrypted_content]
    # Decode base64 content
    decoded_content = Base64.decode64(base64_content)
        
    # Force encoding to UTF-8 before custom decoding
    decoded_content = decoded_content.force_encoding('UTF-8')
        
    # Custom decoding for this specific encoding
    decoded_content = custom_decode(decoded_content)
        
    # Save to the database
    field_data = FieldDatum.create(base64_content: base64_content, decoded_content: decoded_content)
    
    # Respond with decoded content, ensuring it's properly encoded for JSON
    render json: { decoded_content: decoded_content }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def custom_decode(text)
    text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
        .gsub(/׳(.)/) { $1 }
        .gsub('׳', '')
  end
end
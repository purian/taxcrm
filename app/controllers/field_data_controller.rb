# app/controllers/field_data_controller.rb
class FieldDataController < ApplicationController
  layout false
  def new
    # Renders a form for inputting base64 content
  end
  def decode    
    base64_content = params[:base64_content]

    # Decode base64 content
    decoded_content = Base64.decode64(base64_content)
    
    # Save to the database
    field_data = FieldDatum.create(base64_content: base64_content, decoded_content: decoded_content)

    # Respond with decoded content
    render json: { decoded_content: decoded_content }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
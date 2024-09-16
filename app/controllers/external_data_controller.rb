class ExternalDataController < ApplicationController
  before_action :authenticate

  def index
    # Add your index action logic here
    @leads = Lead.all # Assuming you have a Lead model
  end

  def update_lead_phone_number
    # Add your update_lead_phone_number action logic here
    # For example:
    lead = Lead.find(params[:id])
    if lead.update(phone_number: params[:phone_number])
      render json: { success: true, message: 'Phone number updated successfully' }
    else
      render json: { success: false, errors: lead.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      # Replace with your actual authentication logic
      username == 'admin' && password == 'secret'
    end
  end
end
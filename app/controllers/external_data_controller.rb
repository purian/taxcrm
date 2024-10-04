class ExternalDataController < ApplicationController
  before_action :authenticate
  layout false
  def index
    @leads = Lead.where('"PhoneNumber" = \'000\' OR "LeadStatusId_Name" = \'חסר נייד\'')
      .left_outer_joins(:external_details)
      .where(external_details: { id: nil })
      .order(:CompanyId)
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

  def create
    external_detail_params = params.require(:external_detail).permit(:object_id, :object_type, :phone_number, :comment, :is_valid)
    external_detail_params[:is_valid] = external_detail_params[:is_valid] != 'false'
    external_detail_params[:object_type] = 'Lead' # Assuming all records are for Leads

    # Remove blank phone number if the record is invalid
    external_detail_params.delete(:phone_number) if external_detail_params[:phone_number].blank? && !external_detail_params[:is_valid]

    external_detail = ExternalDetail.new(external_detail_params)

    if external_detail.save
      flash[:notice] = 'External detail created successfully'
      redirect_to external_data_path
    else
      flash[:alert] = external_detail.errors.full_messages.join(', ')
      @leads = Lead.where('"PhoneNumber" = \'000\' OR "LeadStatusId_Name" = \'חסר נייד\'')
      render :index
    end
  end

  def all_external_details
    @valid_details = ExternalDetail.includes(:lead).where(is_valid: true).order(created_at: :desc)
    @invalid_details = ExternalDetail.includes(:lead).where(is_valid: false).order(created_at: :desc)
    @active_tab = params[:tab] || 'valid'

  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      # Replace with your actual authentication logic
      username == 'admin' && password == 'secret'
    end
  end
end
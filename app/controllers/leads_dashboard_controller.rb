class LeadsDashboardController < ApplicationController
  def index
    # Assuming Lead model exists with relevant fields
    @leads = Lead.all

    year = params[:year] || Date.current.year.to_s
    @filtered_leads = @leads.where("strftime('%Y', created_at) = ?", year)

    @total_leads_over_time = @filtered_leads.group_by_day(:created_at).count
    @leads_by_status = @filtered_leads.group(:LeadStatusId_Name).count
    
    
    
    @top_lead_owners = @filtered_leads.group(:LeadOwnerId_name).count
  end

  
end
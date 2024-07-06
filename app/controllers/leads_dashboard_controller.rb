class LeadsDashboardController < ApplicationController
  def index
    # Assuming Lead model exists with relevant fields
    @leads = Lead.all

    year = params[:year] || Date.current.year.to_s
    @filtered_leads = @leads.where("strftime('%Y', created_at) = ?", year)

    @total_leads_over_time = @filtered_leads.group_by_day(:created_at).count
    @leads_by_status = @filtered_leads.group(:LeadStatusId_Name).count
    @lead_conversion_rate = calculate_conversion_rate(@filtered_leads)
    @leads_by_source = @filtered_leads.group(:SourceList).count
    @average_time_to_conversion = calculate_average_time_to_conversion(@filtered_leads)
    @top_lead_owners = @filtered_leads.group(:LeadOwnerId_name).count
  end

  private

  def calculate_conversion_rate(leads)
    total_leads = leads.count
    converted_leads = leads.where(LeadStatusId_Name: 'Converted').count
    return 0 if total_leads.zero?
    (converted_leads.to_f / total_leads) * 100
  end

  def calculate_average_time_to_conversion(leads)
    converted_leads = leads.where(LeadStatusId_Name: 'Converted')
    return 0 if converted_leads.empty?

    total_days = converted_leads.sum do |lead|
      (lead.updated_at.to_date - lead.created_at.to_date).to_i
    end

    total_days.to_f / converted_leads.count
  end
end
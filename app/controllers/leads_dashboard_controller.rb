class LeadsDashboardController < ApplicationController
  include LeadsHelper
  def index
    # Assuming Lead model exists with relevant fields
    @leads = Lead.all

    year = params[:year] || Date.current.year.to_s
    @filtered_leads = @leads.where("strftime('%Y', created_at) = ?", year)

    @total_leads_over_time_month = @filtered_leads.group_by_month(:created_at).count
    @total_leads_over_time_week = @filtered_leads.group_by_week(:created_at).count
    @total_leads_over_time_3_month_ago_by_days = @filtered_leads.where(created_at: 3.month.ago..).group_by_day(:created_at).count
    @leads_by_status = @filtered_leads.group(:LeadStatusId_Name).count
    @leads_chart_data = leads_chart_data
    # ["לא רלוונטי", "ליד חדש", "ממתין לחיסיון  לקוח", "ליד בטיפול", nil, "חסר נייד", "נשלחו מסמכים להחתמת לקוח", "ממתין לצילומים מהלקוח", "לקוח"]
    
    @top_lead_owners = @filtered_leads.group(:LeadOwnerId_name).count
  end

  
end
class LeadsController < ApplicationController
  def index
    @lead_owners = Lead.distinct.pluck(:LeadOwnerId_name)
  end

  def filter
    lead_owner = params[:lead_owner]
    lawyers = Lead.where(LeadOwnerId_name: lead_owner)
                  .select(:Lawyers_Name, :created_at)
                  .group_by { |lead| lead.Lawyers_Name }
                  .transform_values { |leads| leads.group_by { |lead| lead.created_at.year } }

    lawyers_with_counts = lawyers.transform_values do |years|
      years.transform_values(&:count)
    end

    render json: { lawyers: lawyers_with_counts }
  end

  def details
    lead_owner = params[:lead_owner]
    lawyer = params[:lawyer]
    year = params[:year].to_i

    start_date = Date.new(year)
    end_date = start_date.end_of_year

    @leads = Lead.where(LeadOwnerId_name: lead_owner, Lawyers_Name: lawyer)
                 .where(created_at: start_date..end_date)
                 .group_by_week(:created_at)
                 .group(:LeadStatusId_Name)
                 .count

    render json: { leads: @leads }
  end

  def show_leads
    week_start = Date.parse(params[:week_start])
    week_end = week_start.end_of_week

    @leads = Lead.where(created_at: week_start..week_end, LeadStatusId_Name: params[:status])
    render json: {
      leads: @leads.map do |lead|
        {
          id: lead.id,
          Name: lead.Name,
          Email: lead.Email,
          PhoneNumber: lead.PhoneNumber,
          LeadStatusId_Name: lead.LeadStatusId_Name,
          LeadOwnerId_name: lead.LeadOwnerId_name,
          Documentation: render_to_string(partial: 'documentation', locals: { documentation: lead.Documentation })
        }
      end
    }
  end
end
# app/helpers/leads_helper.rb
module LeadsHelper
  def leads_chart_data
    data = Lead.group(:LeadOwnerId_name, :LeadStatusId_Name).count

    grouped_data = data.each_with_object({}) do |((owner, status), count), result|
      result[owner] ||= {}
      result[owner][status] = count
    end

    grouped_data
  end
end
require 'csv'

# Fetch the data
data = Lead.where.not(Whenwasthepropertybought: nil, YearOfSaleNew: nil).pluck('LeadStatusId_Name', 'Name', 'Number', 'Whenwasthepropertybought', 'YearOfSaleNew', 'LeadOwnerId_name', 'NextNote')

# Generate the CSV content
def generate_csv(data)
  CSV.generate(headers: true) do |csv|
    csv << ['LeadStatusId_Name', 'Name', 'Number', 'Whenwasthepropertybought', 'YearOfSaleNew', 'LeadOwnerId_name', 'NextNote'] # Add headers
    data.each do |row|
      csv << row
    end
  end
end

csv_content = generate_csv(data)

# Save the CSV to a file
File.write('leads.csv', csv_content)

puts "CSV file generated successfully: leads.csv"
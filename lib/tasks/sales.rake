namespace :sales do
  desc "Process timeline data for all sales"
  task process_timeline: :environment do
    Sale.find_each do |sale|
      begin
        sale.process_timeline
        puts "Processed timeline for Sale ID: #{sale.id}"
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      end
    end
  end
end

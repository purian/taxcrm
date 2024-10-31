namespace :sales do
  desc "Process timeline data for all sales"
  task process_timeline: :environment do
    Sale.find_each(batch_size: 100) do |sale|
      next unless sale.real_sales.empty?
      begin
        sale.process_timeline
        puts "Processed timeline for Sale ID: #{sale.id}"
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      ensure
        sleep(2) # Add a small delay between requests
      end
    end
  end
end

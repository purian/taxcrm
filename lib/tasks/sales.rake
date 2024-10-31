namespace :sales do
  desc "Process timeline data for all sales"
  task process_timeline: :environment do
    batch_size = 50
    delay_between_batches = 120 # 5 minutes
    counter = 0

    Sale.find_each(batch_size: batch_size) do |sale|
      begin
        if sale.real_sales.empty?
          puts "Processing Sale ID: #{sale.id}"
          puts "Real Sales: #{sale.real_sales.count}"
          sale.process_timeline 
          puts "Processed timeline for Sale ID: #{sale.id}"
        end
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      end
      
      if (sale.id % batch_size) == 0 and counter > 500
        counter = 0
        puts "Sleeping for #{delay_between_batches} seconds between batches..."
        sleep(delay_between_batches)
      end
    end
  end
end

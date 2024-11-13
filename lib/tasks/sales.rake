namespace :sales do
  desc "Process timeline data for all sales"
  task process_timeline: :environment do
    batch_size = 500
    delay_between_batches = 120 # 5 minutes
    counter = 1
    total_missing_sales = Sale.joins(:real_sales).where(real_sales: { updated_at: ..1.day.ago.end_of_day }).count
    # total_missing_sales = Sale.where.missing(:real_sales).count
    # Sale.where.missing(:real_sales).find_each(batch_size: batch_size) do |sale|
    Sale.joins(:real_sales).where(real_sales: { updated_at: ..1.day.ago.end_of_day }).find_each(batch_size: batch_size) do |sale|
      begin  
        puts "Total process sales out of missing sales: #{counter} / #{total_missing_sales}"
        # if sale.real_sales.empty?
          puts "Processing Sale ID: #{sale.id}"
          puts "Real Sales: #{sale.real_sales.count}"
          sale.process_timeline 
          sleep(0.75)
          counter += 1
          puts "Processed timeline for Sale ID: #{sale.id}"
        # end
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      end
      
      if (sale.id % batch_size == 0 && counter % 500 == 0)
        puts "Sleeping for #{delay_between_batches} seconds between batches..."
        sleep(delay_between_batches)
      end
    end
  end

  task process_overdue_collection_sales: :environment do
    batch_size = 500
    delay_between_batches = 120 # 5 minutes
    counter = 1
    total_overdue_sales = Sale.joins(:real_sales)
                             .where('real_sales.next_step_date < ?', Date.today)
                             .where(real_sales: { cap_status_name: 'בגבייה' })
                             .count

    Sale.joins(:real_sales)
        .where('real_sales.next_step_date < ?', Date.today)
        .where(real_sales: { cap_status_name: 'בגבייה' })
        .find_each(batch_size: batch_size) do |sale|
      begin  
        puts "Total process overdue collection sales: #{counter} / #{total_overdue_sales}"
        puts "Processing Sale ID: #{sale.id}"
        puts "Real Sales: #{sale.real_sales.count}"
        sale.process_timeline 
        sleep(0.75)
        counter += 1
        puts "Processed timeline for Sale ID: #{sale.id}"
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      end
      
      if (sale.id % batch_size == 0 && counter % 500 == 0)
        puts "Sleeping for #{delay_between_batches} seconds between batches..."
        sleep(delay_between_batches)
      end
    end
  end

  desc "Update next step dates for sales"
  task :update_next_step_dates, [:date_type] => :environment do |t, args|
    date_type = args[:date_type] || 'today'
    
    sales = case date_type
    when 'today'
      Sale.joins(:real_sales)
          .where(real_sales: { next_step_date: Date.today })
          .where(real_sales: { updated_at: ..2.hours.ago })
    when 'upcoming'
      Sale.joins(:real_sales)
          .where('real_sales.next_step_date >= ?', Date.today)
          .where(real_sales: { updated_at: ..2.hours.ago })
    when 'past'
      Sale.joins(:real_sales)
          .where('real_sales.next_step_date < ?', Date.today)
          .where(real_sales: { updated_at: ..2.hours.ago })
    when 'week'
      Sale.joins(:real_sales)
          .where(real_sales: { next_step_date: Date.today.beginning_of_week..Date.today.end_of_week })
          .where(real_sales: { updated_at: ..2.hours.ago })
    else
      puts "Invalid date type. Use 'today', 'upcoming', 'past', or 'week'"
      return
    end

    total_sales = sales.count
    counter = 1

    puts "Found #{total_sales} sales to update for #{date_type}"

    sales.find_each(batch_size: 100) do |sale|
      begin
        puts "Processing #{counter}/#{total_sales}: Sale ID #{sale.id}"
        sale.process_timeline
        sleep(0.75)
        counter += 1
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      end

      if counter % 100 == 0
        puts "Sleeping for 60 seconds between batches..."
        sleep(60)
      end
    end
  end
end

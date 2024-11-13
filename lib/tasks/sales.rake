namespace :sales do
  desc "Process timeline data for all sales"
  task process_timeline: :environment do
    process_sales(
      query: Sale.joins(:real_sales).where(real_sales: { updated_at: ..1.day.ago.end_of_day }),
      batch_size: 500,
      delay_between_batches: 60,
      description: "missing sales"
    )
  end

  desc "Process overdue collection sales"
  task process_overdue_collection_sales: :environment do
    process_sales(
      query: Sale.joins(:real_sales)
                 .where('real_sales.next_step_date < ?', Date.today)
                 .where(real_sales: { cap_status_name: 'בגבייה' }),
      batch_size: 500,
      delay_between_batches: 60,
      description: "overdue collection sales"
    )
  end

  desc "Update next step dates for sales"
  task :update_next_step_dates, [:date_type] => :environment do |t, args|
    date_type = args[:date_type] || 'today'

    sales_scope = Sale.joins(:real_sales).where(real_sales: { updated_at: ..2.hours.ago })
    sales = case date_type
            when 'today'
              sales_scope.where(real_sales: { next_step_date: Date.today })
            when 'upcoming'
              sales_scope.where('real_sales.next_step_date >= ?', Date.today)
            when 'past'
              sales_scope.where('real_sales.next_step_date < ?', Date.today)
            when 'week'
              sales_scope.where(real_sales: { next_step_date: Date.today.beginning_of_week..Date.today.end_of_week })
            else
              puts "Invalid date type. Use 'today', 'upcoming', 'past', or 'week'"
              return
            end

    process_sales(
      query: sales,
      batch_size: 100,
      delay_between_batches: 60,
      description: "#{date_type} sales"
    )
  end

  def process_sales(query:, batch_size:, delay_between_batches:, description:)
    total_sales = query.count
    counter = 1
    puts "Found #{total_sales} #{description} to process."

    query.find_each(batch_size: batch_size) do |sale|
      begin
        puts "Processing #{counter}/#{total_sales}: Sale ID #{sale.id}"
        sale.process_timeline
        counter += 1
      rescue => e
        puts "Error processing Sale ID: #{sale.id} - #{e.message}"
      end

      # Delay between batches only
      if counter % batch_size == 0
        puts "Sleeping for #{delay_between_batches} seconds between batches..."
        sleep(delay_between_batches)
      end
    end

    puts "Finished processing #{description}."
  end
end
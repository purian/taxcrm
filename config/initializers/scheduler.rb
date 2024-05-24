require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# Schedule to run daily at midnight
scheduler.cron '0 0 * * *' do
  FetchSalesDataService.new.call
end
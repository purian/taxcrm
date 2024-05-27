require 'rufus-scheduler'
require 'logger'

Rails.application.config.after_initialize do
  Thread.new do
    # Initialize the logger
    logger = Logger.new('log/scheduler.log', 'daily')
    logger.level = Logger::INFO

    scheduler = Rufus::Scheduler.new

    # Schedule to run daily at midnight
    scheduler.cron '40 5 * * *' do
      logger.info("Scheduler started at #{Time.now}")

      begin
        logger.info("Starting FetchSalesDataService at #{Time.now}")
        FetchSalesDataService.new.call
        logger.info("Completed FetchSalesDataService at #{Time.now}")

        logger.info("Starting FetchClientsDataService at #{Time.now}")
        FetchClientsDataService.new.call
        logger.info("Completed FetchClientsDataService at #{Time.now}")

        logger.info("Starting FetchContactsDataService at #{Time.now}")
        FetchContactsDataService.new.call
        logger.info("Completed FetchContactsDataService at #{Time.now}")

        logger.info("Starting FetchLeadsDataService at #{Time.now}")
        FetchLeadsDataService.new.call
        logger.info("Completed FetchLeadsDataService at #{Time.now}")

        logger.info("Starting FetchReferralsDataService at #{Time.now}")
        FetchReferralsDataService.new.call
        logger.info("Completed FetchReferralsDataService at #{Time.now}")
      rescue => e
        logger.error("An error occurred: #{e.message}")
        logger.error(e.backtrace.join("\n"))
      end

      logger.info("Scheduler finished at #{Time.now}")
    end

    scheduler.join
  end
end
# lib/tasks/phone_number_duplicate_check.rake
namespace :phone_number do
  desc "Check for duplicate phone numbers across Lead, Client, and Sale"
  task check_duplicates: :environment do
    PhoneNumberDuplicateChecker.check
  end
end
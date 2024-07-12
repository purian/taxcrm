# lib/tasks/unique_phone_number_check.rake
namespace :phone_number do
  desc "Check for unique phone numbers in Sale, Client, and Lead"
  task check_unique: :environment do
    UniquePhoneNumberChecker.check
  end
end
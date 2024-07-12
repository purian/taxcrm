# app/services/unique_phone_number_checker.rb
class UniquePhoneNumberChecker
  def self.check
    new.check
  end

  def check
    sale_phone_numbers = Sale.pluck(:AccountId_PhoneNumber).compact
    client_phone_numbers = Client.pluck(:PhoneNumber).compact
    lead_phone_numbers = Lead.pluck(:PhoneNumber).compact

    sale_in_lead_count = count_duplicates(sale_phone_numbers, lead_phone_numbers)
    sale_in_client_count = count_duplicates(sale_phone_numbers, client_phone_numbers)
    client_in_lead_count = count_duplicates(client_phone_numbers, lead_phone_numbers)

    highlight_duplicate_counts('Sale', 'Lead', sale_in_lead_count)
    highlight_duplicate_counts('Sale', 'Client', sale_in_client_count)
    highlight_duplicate_counts('Client', 'Lead', client_in_lead_count)
  end

  private

  def count_duplicates(primary_list, comparison_list)
    primary_list.uniq.count { |phone| comparison_list.include?(phone) }
  end

  def highlight_duplicate_counts(model1, model2, count)
    puts "#{count} records from #{model1} have the same phone number in #{model2}"
  end
end
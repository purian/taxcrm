# app/services/phone_number_duplicate_checker.rb
class PhoneNumberDuplicateChecker
  def self.check
    new.check
  end

  def check
    phone_numbers = collect_phone_numbers
    duplicates = find_duplicates(phone_numbers)

    highlight_duplicates(duplicates)
  end

  private

  def collect_phone_numbers
    phone_numbers = []

    phone_numbers += Lead.pluck(:id, :PhoneNumber).map { |id, phone| { model: 'Lead', id: id, phone: phone } }
    phone_numbers += Client.pluck(:id, :PhoneNumber).map { |id, phone| { model: 'Client', id: id, phone: phone } }
    phone_numbers += Sale.pluck(:id, :AccountId_PhoneNumber).map { |id, phone| { model: 'Sale', id: id, phone: phone } }

    phone_numbers
  end

  def find_duplicates(phone_numbers)
    grouped = phone_numbers.group_by { |entry| entry[:phone] }
    grouped.select { |phone, entries| entries.size > 1 }
  end

  def highlight_duplicates(duplicates)
    duplicates.each do |phone, entries|
      puts "Phone Number: #{phone} is duplicated in:"
      entries.each do |entry|
        puts " - #{entry[:model]} with ID: #{entry[:id]}"
      end
    end
  end
end
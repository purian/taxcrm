# db/migrate/XXXXXX_add_extra_fields_to_leads.rb
class AddExtraFieldsToLeads < ActiveRecord::Migration[6.1]
  def change
    add_column :leads, :NextNote, :datetime
  end
end
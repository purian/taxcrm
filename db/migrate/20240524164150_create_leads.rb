class CreateLeads < ActiveRecord::Migration[7.1]
  def change
    create_table :leads do |t|
      t.string :objectId
      t.string :Name
      t.string :Email
      t.string :PhoneNumber
      t.string :LeadStatusId_Name
      t.string :LeadOwnerId_name
      t.boolean :IsAccount

      t.timestamps
    end
  end
end

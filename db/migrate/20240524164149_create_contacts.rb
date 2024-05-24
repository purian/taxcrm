class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :objectId
      t.string :Name
      t.string :Email
      t.string :PhoneNumber
      t.string :CellPhone
      t.string :Position
      t.string :AccountId_Name
      t.string :OwnerId_name
      t.boolean :AccountId_IsAccount

      t.timestamps
    end
  end
end

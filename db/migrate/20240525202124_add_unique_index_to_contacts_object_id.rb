class AddUniqueIndexToContactsObjectId < ActiveRecord::Migration[7.0]
  def change
    add_index :contacts, :objectId, unique: true
  end
end
class AddUniqueIndexToClientsObjectId < ActiveRecord::Migration[7.0]
  def change
    add_index :clients, :objectId, unique: true
  end
end
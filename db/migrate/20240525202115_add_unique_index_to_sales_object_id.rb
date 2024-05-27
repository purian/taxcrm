class AddUniqueIndexToSalesObjectId < ActiveRecord::Migration[7.0]
  def change
    add_index :sales, :objectId, unique: true
  end
end
class AddObjectIdsToRealSales < ActiveRecord::Migration[7.0]
  def change
    add_column :real_sales, :objectId, :string
    add_column :real_sales, :objectIdValue, :string
    
    add_index :real_sales, :objectId
    add_index :real_sales, :objectIdValue
  end
end

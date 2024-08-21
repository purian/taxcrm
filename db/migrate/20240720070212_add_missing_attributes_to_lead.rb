class AddMissingAttributesToLead < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :YearOfSaleNew, :string
    add_column :leads, :Whenwasthepropertybought, :string    
  end
end

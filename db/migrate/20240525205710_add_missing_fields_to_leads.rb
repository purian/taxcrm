class AddMissingFieldsToLeads < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :CompanyId, :string
    add_column :leads, :Number, :string
    add_column :leads, :Documentation, :text
    add_column :leads, :SourceList, :text
    add_column :leads, :PraiseTax, :string
    add_column :leads, :Lawyers_Name, :string    
  end
end
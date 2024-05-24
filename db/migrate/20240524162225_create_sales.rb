class CreateSales < ActiveRecord::Migration[7.1]
  def change
    create_table :sales do |t|
      t.string :objectId
      t.string :Name
      t.string :AccNumber
      t.string :AccountId_Name
      t.string :AccountId_CompanyId
      t.string :AccountId_PhoneNumber
      t.string :SaleStatusId_Name
      t.string :CAPStatus_Name
      t.string :PraiseTax
      t.datetime :BookkeepingDate
      t.boolean :AccountId_IsAccount

      t.timestamps
    end
  end
end

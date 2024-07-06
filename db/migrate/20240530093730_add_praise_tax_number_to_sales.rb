class AddPraiseTaxNumberToSales < ActiveRecord::Migration[7.1]
  def change
    add_column :sales, :PraiseTaxNumber, :integer
  end
end
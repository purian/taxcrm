class AddMissingFieldsToRealSales < ActiveRecord::Migration[7.0]
  def change
    add_column :real_sales, :account_comment, :text
    add_column :real_sales, :cpa_name_text, :string  # To store CPAName->Name
    add_column :real_sales, :cap_status_name, :string # To store CAPStatus->Name
    add_column :real_sales, :submission_date, :datetime
  end
end

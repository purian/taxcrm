class AddDetailsToTimeLines < ActiveRecord::Migration[7.1]
  def change
    add_column :time_lines, :sale_total, :integer
    add_column :time_lines, :sale_name, :string
    add_column :time_lines, :sale_status_id, :string
    add_column :time_lines, :account_id, :string
    add_column :time_lines, :sale_owner_id, :string
    add_column :time_lines, :sale_id, :string
    add_column :time_lines, :user_id, :string
    add_column :time_lines, :account_name, :string
  end
end
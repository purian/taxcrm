class RemoveUserIdFromTimeLines < ActiveRecord::Migration[7.1]
  def change
    remove_column :time_lines, :user_id, :integer
  end
end
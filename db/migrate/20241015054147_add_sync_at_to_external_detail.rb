class AddSyncAtToExternalDetail < ActiveRecord::Migration[7.1]
  def change
    add_column :external_details, :sync_at, :datetime
  end
end

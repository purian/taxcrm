class CreateClientExternalDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :client_external_details do |t|
      t.string :client_id
      t.string :client_number
      t.string :client_name
      t.string :client_phone_number
      t.datetime :sync_at

      t.timestamps
    end
  end
end 
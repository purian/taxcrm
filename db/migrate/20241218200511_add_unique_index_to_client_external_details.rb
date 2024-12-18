class AddUniqueIndexToClientExternalDetails < ActiveRecord::Migration[7.1]
  def change
    add_index :client_external_details, 
              [:client_number, :client_phone_number, :data_owner], 
              unique: true,
              name: 'index_client_external_details_on_number_phone_owner'
  end
end
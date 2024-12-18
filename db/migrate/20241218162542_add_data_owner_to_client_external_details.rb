class AddDataOwnerToClientExternalDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :client_external_details, :data_owner, :string
  end
end

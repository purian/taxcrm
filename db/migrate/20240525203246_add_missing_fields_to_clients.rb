class AddMissingFieldsToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :Number2, :string
    add_column :clients, :Number, :string
    add_column :clients, :CompanyId, :string
    add_column :clients, :LeadOwnerId_name, :string
    add_column :clients, :DateBecomeCustomer, :datetime
    add_column :clients, :Documentation, :text
    add_column :clients, :IsAccount, :boolean
  end
end
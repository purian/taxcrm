class CreateAccountingHeaders < ActiveRecord::Migration[6.1]
  def change
    create_table :accounting_headers do |t|
      t.string :object_id, null: false
      t.string :object_type, null: false
      t.string :external_object_id, null: false
      t.datetime :document_date
      t.integer :document_number
      t.string :doc_type_name
      t.string :name
      t.decimal :total_sum, precision: 10, scale: 2
      t.string :email
      t.string :file_name
      t.string :file_url
      t.boolean :file_private
      t.datetime :external_created_at
      t.datetime :external_updated_at

      t.timestamps
    end

    add_index :accounting_headers, [:object_type, :object_id]
    add_index :accounting_headers, :external_object_id, unique: true
  end
end
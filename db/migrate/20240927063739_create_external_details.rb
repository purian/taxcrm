class CreateExternalDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :external_details do |t|
      t.string :object_id, null: false
      t.string :object_type, null: false
      t.string :phone_number
      t.string :comment
      t.boolean :is_valid, default: true

      t.timestamps
    end

    add_index :external_details, [:object_id, :object_type]
  end
end
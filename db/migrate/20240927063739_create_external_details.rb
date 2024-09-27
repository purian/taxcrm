class CreateExternalDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :external_details do |t|
      t.references :object, polymorphic: true
      t.string :phone_number
      t.string :comment
      t.boolean :invalid, default: false

      t.timestamps
    end
  end
end
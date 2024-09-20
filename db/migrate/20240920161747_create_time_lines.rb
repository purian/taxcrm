class CreateTimeLines < ActiveRecord::Migration[6.1]
  def change
    create_table :time_lines do |t|
      t.string :objectId
      t.string :event
      t.string :object_class
      t.string :object_id_value
      t.string :name
      t.text :data
      t.boolean :pinned
      t.boolean :last
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :time_lines, :object_id_value
    add_index :time_lines, :object_class
  end
end
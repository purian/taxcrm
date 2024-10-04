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
      t.bigint :user_id  # Change this line

      t.timestamps
    end

    add_index :time_lines, :object_id_value
    add_index :time_lines, :object_class
    add_index :time_lines, :user_id  # Add this line
  end
end
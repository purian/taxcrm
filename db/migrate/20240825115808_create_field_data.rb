class CreateFieldData < ActiveRecord::Migration[7.1]
  def change
    create_table :field_data do |t|
      t.text :base64_content
      t.text :decoded_content

      t.timestamps
    end
  end
end

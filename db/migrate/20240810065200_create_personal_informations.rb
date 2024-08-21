class CreatePersonalInformations < ActiveRecord::Migration[7.1]
  def change
    create_table :personal_informations do |t|
      t.integer :oid
      t.string :first_name
      t.string :last_name
      t.integer :voter_id
      t.integer :campaign_oid
      t.integer :ballot_box_oid
      t.boolean :deleted
      t.string :father_name
      t.string :street
      t.string :house_number
      t.string :apartment_number
      t.integer :voter_number
      t.integer :ballot_box_number
      t.integer :city_oid

      t.timestamps
    end
  end
end

class CreateReferrals < ActiveRecord::Migration[7.1]
  def change
    create_table :referrals do |t|
      t.string :objectId
      t.string :Name
      t.string :PhoneNumber
      t.string :OwnerId_name
      t.string :City_Name
      t.string :StatusLaw_Name
      t.string :LinkingFactor

      t.timestamps
    end
  end
end

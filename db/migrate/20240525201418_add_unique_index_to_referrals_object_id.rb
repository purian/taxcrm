class AddUniqueIndexToReferralsObjectId < ActiveRecord::Migration[7.0]
  def change
    add_index :referrals, :objectId, unique: true
  end
end
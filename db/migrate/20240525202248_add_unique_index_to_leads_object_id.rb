class AddUniqueIndexToLeadsObjectId < ActiveRecord::Migration[7.0]
  def change
    add_index :leads, :objectId, unique: true
  end
end
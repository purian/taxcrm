class AddLastDetailsScrapedAtToLead < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :last_details_scraped_at, :datetime
  end
end

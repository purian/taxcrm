class AddMissingFieldsToSales < ActiveRecord::Migration[7.1]
    def change
      add_column :sales, :closing_date, :datetime
      add_column :sales, :cpa_date, :datetime
      add_column :sales, :cpa_followup_date, :datetime
      add_column :sales, :next_step_date, :datetime
      add_column :sales, :refun_tax_made_date, :datetime
  
      # CPA and Sales related
      add_column :sales, :cpa_name_id, :string  # For CPAName relation
      add_column :sales, :cpa_owner_id, :string # For CpaOwnerId relation
      add_column :sales, :owner_id, :string     # For OwnerId relation
      add_column :sales, :owner_username, :string
      add_column :sales, :owner_name, :string
      add_column :sales, :owner_active, :boolean
      add_column :sales, :owner_job, :string
      add_column :sales, :owner_phone, :string
      add_column :sales, :owner_extension, :string
      add_column :sales, :owner_last_success_login, :datetime
      
      add_column :sales, :sale_email, :string
      add_column :sales, :sale_landline, :string
      add_column :sales, :sale_mobile, :string
  
      # Financial fields
      add_column :sales, :total, :decimal, precision: 10, scale: 2
      add_column :sales, :total_before_discount, :decimal, precision: 10, scale: 2
      add_column :sales, :discount, :decimal, precision: 10, scale: 2
      add_column :sales, :discount_type, :string
      add_column :sales, :discount_value, :decimal, precision: 10, scale: 2
      add_column :sales, :est_refund, :decimal, precision: 10, scale: 2
      add_column :sales, :invoice_issued, :boolean, default: false
  
      # Status and comments
      add_column :sales, :cpa_chat, :text
      add_column :sales, :all_extra_info, :text
      add_column :sales, :pakid_shoma_id, :string  # For PakidShoma relation
      add_column :sales, :pakid_shoma_name, :string
      add_column :sales, :signed_sms, :boolean, default: false
  
      # Additional fields from nested relations
      add_column :sales, :lawyer_id, :string
      add_column :sales, :lawyer_name, :string
      add_column :sales, :lawyer_address, :string
      add_column :sales, :lawyer_owner_id, :string
      add_column :sales, :lawyer_phone_number, :string
      add_column :sales, :lawyer_description, :text
      add_column :sales, :lawyer_office_phone, :string
      add_column :sales, :lawyer_email, :string
      add_column :sales, :lawyer_linking_factor, :string
      add_column :sales, :lawyer_comment, :text
      add_column :sales, :lawyer_status_law, :string
  
      # Status related fields
      add_column :sales, :sale_status_id, :string
      add_column :sales, :sale_status_name, :string
      add_column :sales, :sale_status_probability, :integer
  
      # Add indexes for foreign keys
      add_index :sales, :cpa_name_id
      add_index :sales, :cpa_owner_id
      add_index :sales, :owner_id
      add_index :sales, :pakid_shoma_id
      add_index :sales, :lawyer_id
      add_index :sales, :sale_status_id
    end
end
class CreateRealSales < ActiveRecord::Migration[7.0]
  def change
    create_table :real_sales do |t|
      t.references :sale, foreign_key: true
      
      # Date fields
      t.datetime :closing_date
      t.datetime :cpa_date
      t.datetime :cpa_followup_date
      t.datetime :next_step_date
      t.datetime :refun_tax_made_date

      # CPA and Sales related
      t.string :cpa_name_id
      t.string :cpa_owner_id
      t.string :owner_id
      t.string :owner_username
      t.string :owner_name
      t.boolean :owner_active
      t.string :owner_job
      t.string :owner_phone
      t.string :owner_extension
      t.datetime :owner_last_success_login
      
      t.string :sale_email
      t.string :sale_landline
      t.string :sale_mobile

      # Financial fields
      t.decimal :total, precision: 10, scale: 2
      t.decimal :total_before_discount, precision: 10, scale: 2
      t.decimal :discount, precision: 10, scale: 2
      t.string :discount_type
      t.decimal :discount_value, precision: 10, scale: 2
      t.decimal :est_refund, precision: 10, scale: 2
      t.boolean :invoice_issued, default: false

      # Status and comments
      t.text :cpa_chat
      t.text :all_extra_info
      t.string :pakid_shoma_id
      t.string :pakid_shoma_name
      t.boolean :signed_sms, default: false

      # Lawyer details
      t.string :lawyer_id
      t.string :lawyer_name
      t.string :lawyer_address
      t.string :lawyer_owner_id
      t.string :lawyer_phone_number
      t.text :lawyer_description
      t.string :lawyer_office_phone
      t.string :lawyer_email
      t.string :lawyer_linking_factor
      t.text :lawyer_comment
      t.string :lawyer_status_law

      # Sale status details
      t.string :sale_status_id
      t.string :sale_status_name
      t.integer :sale_status_probability

      t.timestamps
    end

    add_index :real_sales, :cpa_name_id
    add_index :real_sales, :cpa_owner_id
    add_index :real_sales, :owner_id
    add_index :real_sales, :pakid_shoma_id
    add_index :real_sales, :lawyer_id
    add_index :real_sales, :sale_status_id
  end
end

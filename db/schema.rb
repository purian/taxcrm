# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_12_18_162542) do
  create_table "accounting_headers", force: :cascade do |t|
    t.string "object_id", null: false
    t.string "object_type", null: false
    t.string "external_object_id", null: false
    t.datetime "document_date", precision: nil
    t.integer "document_number"
    t.string "doc_type_name"
    t.string "name"
    t.decimal "total_sum", precision: 10, scale: 2
    t.string "email"
    t.string "file_name"
    t.string "file_url"
    t.boolean "file_private"
    t.datetime "external_created_at", precision: nil
    t.datetime "external_updated_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_object_id"], name: "index_accounting_headers_on_external_object_id", unique: true
    t.index ["object_type", "object_id"], name: "index_accounting_headers_on_object_type_and_object_id"
  end

  create_table "client_external_details", force: :cascade do |t|
    t.string "client_id"
    t.string "client_number"
    t.string "client_name"
    t.string "client_phone_number"
    t.datetime "sync_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "data_owner"
  end

  create_table "clients", force: :cascade do |t|
    t.string "objectId"
    t.string "Name"
    t.string "Email"
    t.string "PhoneNumber"
    t.string "CellPhone"
    t.string "Position"
    t.string "AccountId_Name"
    t.string "OwnerId_name"
    t.boolean "AccountId_IsAccount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "Number2"
    t.string "Number"
    t.string "CompanyId"
    t.string "LeadOwnerId_name"
    t.datetime "DateBecomeCustomer"
    t.text "Documentation"
    t.boolean "IsAccount"
    t.string "Website"
    t.string "PhoneNumber2"
    t.string "Source"
    t.string "OtherSource"
    t.string "Fax"
    t.boolean "Heirs"
    t.integer "NumberOfHeirs"
    t.text "Comment"
    t.string "State"
    t.string "City"
    t.string "Address"
    t.string "StatusId"
    t.string "FamilyStatus"
    t.string "PropertyTypeSold"
    t.string "SoldProperty6Years"
    t.string "Industry"
    t.string "AdditionalAsset"
    t.string "AdditionalSellers"
    t.string "WorkStatus"
    t.string "LeadStatusId"
    t.string "AccountIsHanicapped"
    t.string "TaxType"
    t.string "DocStatus"
    t.string "AddressOfSale"
    t.string "AverageIncome"
    t.string "AverageIncomePartner"
    t.string "DivorceYear"
    t.string "YearOfSale"
    t.boolean "LawyerComissionPayed"
    t.string "SpouseID"
    t.string "Lawyers"
    t.string "ChangedLeadToClient"
    t.string "Rentpayment"
    t.string "NeedPromotion"
    t.boolean "mizrhai"
    t.boolean "Clalit"
    t.boolean "DiscountBank"
    t.string "ChangingLead"
    t.boolean "migdal"
    t.decimal "mortgage", precision: 10, scale: 2
    t.datetime "last_details_scraped_at"
    t.index ["objectId"], name: "index_clients_on_objectId", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "objectId"
    t.string "Name"
    t.string "Email"
    t.string "PhoneNumber"
    t.string "CellPhone"
    t.string "Position"
    t.string "AccountId_Name"
    t.string "OwnerId_name"
    t.boolean "AccountId_IsAccount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["objectId"], name: "index_contacts_on_objectId", unique: true
  end

  create_table "external_details", force: :cascade do |t|
    t.string "object_id", null: false
    t.string "object_type", null: false
    t.string "phone_number"
    t.string "comment"
    t.boolean "is_valid", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sync_at"
    t.index ["object_id", "object_type"], name: "index_external_details_on_object_id_and_object_type"
  end

  create_table "field_data", force: :cascade do |t|
    t.text "base64_content"
    t.text "decoded_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "objectId"
    t.string "Name"
    t.string "Email"
    t.string "PhoneNumber"
    t.string "LeadStatusId_Name"
    t.string "LeadOwnerId_name"
    t.boolean "IsAccount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "CompanyId"
    t.string "Number"
    t.text "Documentation"
    t.text "SourceList"
    t.string "PraiseTax"
    t.string "Lawyers_Name"
    t.string "Website"
    t.string "LeadOwnerId_objectId"
    t.string "LeadOwnerId_username"
    t.boolean "LeadOwnerId_active"
    t.string "LeadOwnerId_job"
    t.string "LeadOwnerId_phone"
    t.string "LeadOwnerId_extension"
    t.string "PhoneNumber2"
    t.string "Fax"
    t.string "State"
    t.string "City"
    t.string "Address"
    t.text "Comment"
    t.boolean "Heirs"
    t.text "AcademicDetails"
    t.text "AlimonyDetails"
    t.text "ArmyDischargeDetails"
    t.text "DonationDetails"
    t.text "FamilyDisabilityDetails"
    t.text "HandicappedDetails"
    t.text "HospitalDetails"
    t.text "ImmigrationCardDetails"
    t.text "NotWorkingDetails"
    t.text "PensionDepositDetails"
    t.text "PensionDetails"
    t.text "ReservesDetails"
    t.text "SecuritiesDetails"
    t.text "UnemploymentFeeDetails"
    t.string "LeadStatusId_objectId"
    t.string "TaxType_objectId"
    t.string "TaxType_Name"
    t.integer "Number2"
    t.string "Campaign"
    t.string "AddressOfSale"
    t.string "AverageIncome"
    t.string "AverageIncomePartner"
    t.string "DivorceYear"
    t.string "YearOfSale"
    t.string "SpouseID"
    t.datetime "NextNote", precision: nil
    t.datetime "last_details_scraped_at"
    t.string "YearOfSaleNew"
    t.string "Whenwasthepropertybought"
    t.index ["objectId"], name: "index_leads_on_objectId", unique: true
  end

  create_table "personal_informations", force: :cascade do |t|
    t.integer "oid"
    t.string "first_name"
    t.string "last_name"
    t.integer "voter_id"
    t.integer "campaign_oid"
    t.integer "ballot_box_oid"
    t.boolean "deleted"
    t.string "father_name"
    t.string "street"
    t.string "house_number"
    t.string "apartment_number"
    t.integer "voter_number"
    t.integer "ballot_box_number"
    t.integer "city_oid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "real_sales", force: :cascade do |t|
    t.integer "sale_id"
    t.datetime "closing_date"
    t.datetime "cpa_date"
    t.datetime "cpa_followup_date"
    t.datetime "next_step_date"
    t.datetime "refun_tax_made_date"
    t.string "cpa_name_id"
    t.string "cpa_owner_id"
    t.string "owner_id"
    t.string "owner_username"
    t.string "owner_name"
    t.boolean "owner_active"
    t.string "owner_job"
    t.string "owner_phone"
    t.string "owner_extension"
    t.datetime "owner_last_success_login"
    t.string "sale_email"
    t.string "sale_landline"
    t.string "sale_mobile"
    t.decimal "total", precision: 10, scale: 2
    t.decimal "total_before_discount", precision: 10, scale: 2
    t.decimal "discount", precision: 10, scale: 2
    t.string "discount_type"
    t.decimal "discount_value", precision: 10, scale: 2
    t.decimal "est_refund", precision: 10, scale: 2
    t.boolean "invoice_issued", default: false
    t.text "cpa_chat"
    t.text "all_extra_info"
    t.string "pakid_shoma_id"
    t.string "pakid_shoma_name"
    t.boolean "signed_sms", default: false
    t.string "lawyer_id"
    t.string "lawyer_name"
    t.string "lawyer_address"
    t.string "lawyer_owner_id"
    t.string "lawyer_phone_number"
    t.text "lawyer_description"
    t.string "lawyer_office_phone"
    t.string "lawyer_email"
    t.string "lawyer_linking_factor"
    t.text "lawyer_comment"
    t.string "lawyer_status_law"
    t.string "sale_status_id"
    t.string "sale_status_name"
    t.integer "sale_status_probability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "objectId"
    t.string "objectIdValue"
    t.text "account_comment"
    t.string "cpa_name_text"
    t.string "cap_status_name"
    t.datetime "submission_date"
    t.index ["cpa_name_id"], name: "index_real_sales_on_cpa_name_id"
    t.index ["cpa_owner_id"], name: "index_real_sales_on_cpa_owner_id"
    t.index ["lawyer_id"], name: "index_real_sales_on_lawyer_id"
    t.index ["objectId"], name: "index_real_sales_on_objectId"
    t.index ["objectIdValue"], name: "index_real_sales_on_objectIdValue"
    t.index ["owner_id"], name: "index_real_sales_on_owner_id"
    t.index ["pakid_shoma_id"], name: "index_real_sales_on_pakid_shoma_id"
    t.index ["sale_id"], name: "index_real_sales_on_sale_id"
    t.index ["sale_status_id"], name: "index_real_sales_on_sale_status_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.string "objectId"
    t.string "Name"
    t.string "PhoneNumber"
    t.string "OwnerId_name"
    t.string "City_Name"
    t.string "StatusLaw_Name"
    t.string "LinkingFactor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["objectId"], name: "index_referrals_on_objectId", unique: true
  end

  create_table "sales", force: :cascade do |t|
    t.string "objectId"
    t.string "Name"
    t.string "AccNumber"
    t.string "AccountId_Name"
    t.string "AccountId_CompanyId"
    t.string "AccountId_PhoneNumber"
    t.string "SaleStatusId_Name"
    t.string "CAPStatus_Name"
    t.string "PraiseTax"
    t.datetime "BookkeepingDate"
    t.boolean "AccountId_IsAccount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "PraiseTaxNumber"
    t.datetime "NextNote", precision: nil
    t.string "WorkStatus_Name"
    t.string "FamilyStatus_Name"
    t.string "AdditionalSellers_Name"
    t.integer "Number"
    t.string "AccountIsHanicapped_Name"
    t.string "KidsUnder18_Name"
    t.string "LeadStatusId_Name"
    t.string "LeadStatusId_StateId"
    t.text "AcademicDetails"
    t.text "AlimonyDetails"
    t.text "ArmyDischargeDetails"
    t.text "DonationDetails"
    t.text "FamilyDisabilityDetails"
    t.text "HospitalDetails"
    t.text "ImmigrationCardDetails"
    t.text "NotWorkingDetails"
    t.text "PensionDepositDetails"
    t.text "PensionDetails"
    t.text "ReservesDetails"
    t.text "SecuritiesDetails"
    t.text "UnemploymentFeeDetails"
    t.text "HandicappedDetails"
    t.string "TaxType_Name"
    t.string "Campaign"
    t.string "AddressOfSale"
    t.string "AverageIncome"
    t.string "AverageIncomePartner"
    t.string "DivorceYear"
    t.string "YearOfSale"
    t.string "Lawyers_Name"
    t.string "Lawyers_Address"
    t.string "Lawyers_OwnerId"
    t.string "Lawyers_PhoneNumber"
    t.text "Lawyers_Description"
    t.string "Lawyers_OfficePhone"
    t.string "Lawyers_Email"
    t.string "Lawyers_LinkingFactor"
    t.text "Lawyers_Comment"
    t.string "Lawyers_StatusLaw"
    t.string "ChangedLeadToClient_username"
    t.string "ChangedLeadToClient_email"
    t.string "ChangedLeadToClient_name"
    t.boolean "ChangedLeadToClient_active"
    t.string "ChangedLeadToClient_extension"
    t.string "ChangedLeadToClient_job"
    t.string "ChangedLeadToClient_phone"
    t.datetime "ChangedLeadToClient_last_success_login", precision: nil
    t.string "LeadIrrelevantReason"
    t.string "FieldAgent"
    t.string "TaxType"
    t.string "LeadStatusId"
    t.boolean "Clientconfidentiality"
    t.string "LeadOwnerId"
    t.string "ChangingLead"
    t.string "Lawyers"
    t.string "ChangedLeadToClient"
    t.string "FamilyStatus"
    t.string "WorkStatus"
    t.string "YearOfSaleNew"
    t.string "AdditionalSellers"
    t.boolean "redemption"
    t.boolean "Futuresale"
    t.string "KidsUnder18"
    t.string "PropertyTypeSold"
    t.string "AccountIsHanicapped"
    t.boolean "accident"
    t.boolean "NeedPromotion"
    t.string "CAPStatus"
    t.string "Source"
    t.string "OtherSource"
    t.string "Email"
    t.string "City"
    t.string "CompanyId"
    t.string "PhoneNumber"
    t.string "Address"
    t.string "PhoneNumber2"
    t.string "Website"
    t.string "Fax"
    t.integer "NumberOfHeirs"
    t.text "Comment"
    t.text "Documentation"
    t.boolean "IsAccount"
    t.datetime "DateBecomeCustomer", precision: nil
    t.string "StatusId"
    t.string "DocStatus"
    t.integer "Number2"
    t.string "updatedByTrigger"
    t.string "AdditionalAsset"
    t.string "SoldProperty6Years"
    t.string "createdBy"
    t.string "updatedBy"
    t.datetime "closing_date"
    t.datetime "cpa_date"
    t.datetime "cpa_followup_date"
    t.datetime "next_step_date"
    t.datetime "refun_tax_made_date"
    t.string "cpa_name_id"
    t.string "cpa_owner_id"
    t.string "owner_id"
    t.string "owner_username"
    t.string "owner_name"
    t.boolean "owner_active"
    t.string "owner_job"
    t.string "owner_phone"
    t.string "owner_extension"
    t.datetime "owner_last_success_login"
    t.string "sale_email"
    t.string "sale_landline"
    t.string "sale_mobile"
    t.decimal "total", precision: 10, scale: 2
    t.decimal "total_before_discount", precision: 10, scale: 2
    t.decimal "discount", precision: 10, scale: 2
    t.string "discount_type"
    t.decimal "discount_value", precision: 10, scale: 2
    t.decimal "est_refund", precision: 10, scale: 2
    t.boolean "invoice_issued", default: false
    t.text "cpa_chat"
    t.text "all_extra_info"
    t.string "pakid_shoma_id"
    t.string "pakid_shoma_name"
    t.boolean "signed_sms", default: false
    t.string "lawyer_id"
    t.string "lawyer_name"
    t.string "lawyer_address"
    t.string "lawyer_owner_id"
    t.string "lawyer_phone_number"
    t.text "lawyer_description"
    t.string "lawyer_office_phone"
    t.string "lawyer_email"
    t.string "lawyer_linking_factor"
    t.text "lawyer_comment"
    t.string "lawyer_status_law"
    t.string "sale_status_id"
    t.string "sale_status_name"
    t.integer "sale_status_probability"
    t.index ["cpa_name_id"], name: "index_sales_on_cpa_name_id"
    t.index ["cpa_owner_id"], name: "index_sales_on_cpa_owner_id"
    t.index ["lawyer_id"], name: "index_sales_on_lawyer_id"
    t.index ["objectId"], name: "index_sales_on_objectId", unique: true
    t.index ["owner_id"], name: "index_sales_on_owner_id"
    t.index ["pakid_shoma_id"], name: "index_sales_on_pakid_shoma_id"
    t.index ["sale_status_id"], name: "index_sales_on_sale_status_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "time_lines", force: :cascade do |t|
    t.string "objectId"
    t.string "event"
    t.string "object_class"
    t.string "object_id_value"
    t.string "name"
    t.text "data"
    t.boolean "pinned"
    t.boolean "last"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sale_total"
    t.string "sale_name"
    t.string "sale_status_id"
    t.string "account_id"
    t.string "sale_owner_id"
    t.string "sale_id"
    t.string "user_id"
    t.string "account_name"
    t.index ["object_class"], name: "index_time_lines_on_object_class"
    t.index ["object_id_value"], name: "index_time_lines_on_object_id_value"
  end

  add_foreign_key "real_sales", "sales"
end

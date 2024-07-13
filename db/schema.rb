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

ActiveRecord::Schema[7.1].define(version: 2024_07_12_222959) do
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
    t.index ["objectId"], name: "index_leads_on_objectId", unique: true
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
    t.index ["objectId"], name: "index_sales_on_objectId", unique: true
  end

end

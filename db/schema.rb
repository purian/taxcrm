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

ActiveRecord::Schema[7.1].define(version: 2024_05_24_164151) do
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
  end

end

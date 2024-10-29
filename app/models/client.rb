# == Schema Information
#
# Table name: clients
#
#  id                      :integer          not null, primary key
#  AccountId_IsAccount     :boolean
#  AccountId_Name          :string
#  AccountIsHanicapped     :string
#  AdditionalAsset         :string
#  AdditionalSellers       :string
#  Address                 :string
#  AddressOfSale           :string
#  AverageIncome           :string
#  AverageIncomePartner    :string
#  CellPhone               :string
#  ChangedLeadToClient     :string
#  ChangingLead            :string
#  City                    :string
#  Clalit                  :boolean
#  Comment                 :text
#  CompanyId               :string
#  DateBecomeCustomer      :datetime
#  DiscountBank            :boolean
#  DivorceYear             :string
#  DocStatus               :string
#  Documentation           :text
#  Email                   :string
#  FamilyStatus            :string
#  Fax                     :string
#  Heirs                   :boolean
#  Industry                :string
#  IsAccount               :boolean
#  LawyerComissionPayed    :boolean
#  Lawyers                 :string
#  LeadOwnerId_name        :string
#  LeadStatusId            :string
#  Name                    :string
#  NeedPromotion           :string
#  Number                  :string
#  Number2                 :string
#  NumberOfHeirs           :integer
#  OtherSource             :string
#  OwnerId_name            :string
#  PhoneNumber             :string
#  PhoneNumber2            :string
#  Position                :string
#  PropertyTypeSold        :string
#  Rentpayment             :string
#  SoldProperty6Years      :string
#  Source                  :string
#  SpouseID                :string
#  State                   :string
#  StatusId                :string
#  TaxType                 :string
#  Website                 :string
#  WorkStatus              :string
#  YearOfSale              :string
#  last_details_scraped_at :datetime
#  migdal                  :boolean
#  mizrhai                 :boolean
#  mortgage                :decimal(10, 2)
#  objectId                :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_clients_on_objectId  (objectId) UNIQUE
#
class Client < ApplicationRecord
  include DecodeHtmlEntities
  has_many :external_details, foreign_key: :object_id, primary_key: :object_id
  has_many :accounting_headers, foreign_key: :object_id, primary_key: :objectId
  has_many :time_lines, foreign_key: 'object_id_value'
end

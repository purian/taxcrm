# == Schema Information
#
# Table name: leads
#
#  id                       :integer          not null, primary key
#  AcademicDetails          :text
#  Address                  :string
#  AddressOfSale            :string
#  AlimonyDetails           :text
#  ArmyDischargeDetails     :text
#  AverageIncome            :string
#  AverageIncomePartner     :string
#  Campaign                 :string
#  City                     :string
#  Comment                  :text
#  CompanyId                :string
#  DivorceYear              :string
#  Documentation            :text
#  DonationDetails          :text
#  Email                    :string
#  FamilyDisabilityDetails  :text
#  Fax                      :string
#  HandicappedDetails       :text
#  Heirs                    :boolean
#  HospitalDetails          :text
#  ImmigrationCardDetails   :text
#  IsAccount                :boolean
#  Lawyers_Name             :string
#  LeadOwnerId_active       :boolean
#  LeadOwnerId_extension    :string
#  LeadOwnerId_job          :string
#  LeadOwnerId_name         :string
#  LeadOwnerId_objectId     :string
#  LeadOwnerId_phone        :string
#  LeadOwnerId_username     :string
#  LeadStatusId_Name        :string
#  LeadStatusId_objectId    :string
#  Name                     :string
#  NextNote                 :datetime
#  NotWorkingDetails        :text
#  Number                   :string
#  Number2                  :integer
#  PensionDepositDetails    :text
#  PensionDetails           :text
#  PhoneNumber              :string
#  PhoneNumber2             :string
#  PraiseTax                :string
#  ReservesDetails          :text
#  SecuritiesDetails        :text
#  SourceList               :text
#  SpouseID                 :string
#  State                    :string
#  TaxType_Name             :string
#  TaxType_objectId         :string
#  UnemploymentFeeDetails   :text
#  Website                  :string
#  Whenwasthepropertybought :string
#  YearOfSale               :string
#  YearOfSaleNew            :string
#  last_details_scraped_at  :datetime
#  objectId                 :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_leads_on_objectId  (objectId) UNIQUE
#
class Lead < ApplicationRecord
  include DecodeHtmlEntities
  has_many :external_details, foreign_key: :object_id, primary_key: :objectId
  has_many :accounting_headers, foreign_key: :object_id, primary_key: :objectId
  has_many :time_lines, foreign_key: 'object_id_value'
end

# == Schema Information
#
# Table name: leads
#
#  id                       :integer          not null, primary key
#  objectId                 :string
#  Name                     :string
#  Email                    :string
#  PhoneNumber              :string
#  LeadStatusId_Name        :string
#  LeadOwnerId_name         :string
#  IsAccount                :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  CompanyId                :string
#  Number                   :string
#  Documentation            :text
#  SourceList               :text
#  PraiseTax                :string
#  Lawyers_Name             :string
#  Website                  :string
#  LeadOwnerId_objectId     :string
#  LeadOwnerId_username     :string
#  LeadOwnerId_active       :boolean
#  LeadOwnerId_job          :string
#  LeadOwnerId_phone        :string
#  LeadOwnerId_extension    :string
#  PhoneNumber2             :string
#  Fax                      :string
#  State                    :string
#  City                     :string
#  Address                  :string
#  Comment                  :text
#  Heirs                    :boolean
#  AcademicDetails          :text
#  AlimonyDetails           :text
#  ArmyDischargeDetails     :text
#  DonationDetails          :text
#  FamilyDisabilityDetails  :text
#  HandicappedDetails       :text
#  HospitalDetails          :text
#  ImmigrationCardDetails   :text
#  NotWorkingDetails        :text
#  PensionDepositDetails    :text
#  PensionDetails           :text
#  ReservesDetails          :text
#  SecuritiesDetails        :text
#  UnemploymentFeeDetails   :text
#  LeadStatusId_objectId    :string
#  TaxType_objectId         :string
#  TaxType_Name             :string
#  Number2                  :integer
#  Campaign                 :string
#  AddressOfSale            :string
#  AverageIncome            :string
#  AverageIncomePartner     :string
#  DivorceYear              :string
#  YearOfSale               :string
#  SpouseID                 :string
#  NextNote                 :datetime
#  last_details_scraped_at  :datetime
#  YearOfSaleNew            :string
#  Whenwasthepropertybought :string
#
require "test_helper"

class LeadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

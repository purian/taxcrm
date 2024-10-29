# == Schema Information
#
# Table name: sales
#
#  id                                     :integer          not null, primary key
#  AcademicDetails                        :text
#  AccNumber                              :string
#  AccountId_CompanyId                    :string
#  AccountId_IsAccount                    :boolean
#  AccountId_Name                         :string
#  AccountId_PhoneNumber                  :string
#  AccountIsHanicapped                    :string
#  AccountIsHanicapped_Name               :string
#  AdditionalAsset                        :string
#  AdditionalSellers                      :string
#  AdditionalSellers_Name                 :string
#  Address                                :string
#  AddressOfSale                          :string
#  AlimonyDetails                         :text
#  ArmyDischargeDetails                   :text
#  AverageIncome                          :string
#  AverageIncomePartner                   :string
#  BookkeepingDate                        :datetime
#  CAPStatus                              :string
#  CAPStatus_Name                         :string
#  Campaign                               :string
#  ChangedLeadToClient                    :string
#  ChangedLeadToClient_active             :boolean
#  ChangedLeadToClient_email              :string
#  ChangedLeadToClient_extension          :string
#  ChangedLeadToClient_job                :string
#  ChangedLeadToClient_last_success_login :datetime
#  ChangedLeadToClient_name               :string
#  ChangedLeadToClient_phone              :string
#  ChangedLeadToClient_username           :string
#  ChangingLead                           :string
#  City                                   :string
#  Clientconfidentiality                  :boolean
#  Comment                                :text
#  CompanyId                              :string
#  DateBecomeCustomer                     :datetime
#  DivorceYear                            :string
#  DocStatus                              :string
#  Documentation                          :text
#  DonationDetails                        :text
#  Email                                  :string
#  FamilyDisabilityDetails                :text
#  FamilyStatus                           :string
#  FamilyStatus_Name                      :string
#  Fax                                    :string
#  FieldAgent                             :string
#  Futuresale                             :boolean
#  HandicappedDetails                     :text
#  HospitalDetails                        :text
#  ImmigrationCardDetails                 :text
#  IsAccount                              :boolean
#  KidsUnder18                            :string
#  KidsUnder18_Name                       :string
#  Lawyers                                :string
#  Lawyers_Address                        :string
#  Lawyers_Comment                        :text
#  Lawyers_Description                    :text
#  Lawyers_Email                          :string
#  Lawyers_LinkingFactor                  :string
#  Lawyers_Name                           :string
#  Lawyers_OfficePhone                    :string
#  Lawyers_OwnerId                        :string
#  Lawyers_PhoneNumber                    :string
#  Lawyers_StatusLaw                      :string
#  LeadIrrelevantReason                   :string
#  LeadOwnerId                            :string
#  LeadStatusId                           :string
#  LeadStatusId_Name                      :string
#  LeadStatusId_StateId                   :string
#  Name                                   :string
#  NeedPromotion                          :boolean
#  NextNote                               :datetime
#  NotWorkingDetails                      :text
#  Number                                 :integer
#  Number2                                :integer
#  NumberOfHeirs                          :integer
#  OtherSource                            :string
#  PensionDepositDetails                  :text
#  PensionDetails                         :text
#  PhoneNumber                            :string
#  PhoneNumber2                           :string
#  PraiseTax                              :string
#  PraiseTaxNumber                        :integer
#  PropertyTypeSold                       :string
#  ReservesDetails                        :text
#  SaleStatusId_Name                      :string
#  SecuritiesDetails                      :text
#  SoldProperty6Years                     :string
#  Source                                 :string
#  StatusId                               :string
#  TaxType                                :string
#  TaxType_Name                           :string
#  UnemploymentFeeDetails                 :text
#  Website                                :string
#  WorkStatus                             :string
#  WorkStatus_Name                        :string
#  YearOfSale                             :string
#  YearOfSaleNew                          :string
#  accident                               :boolean
#  createdBy                              :string
#  objectId                               :string
#  redemption                             :boolean
#  updatedBy                              :string
#  updatedByTrigger                       :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#
# Indexes
#
#  index_sales_on_objectId  (objectId) UNIQUE
#
require "test_helper"

class SaleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

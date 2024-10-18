# == Schema Information
#
# Table name: sales
#
#  id                                      :integer          not null, primary key
#  objectId                                :string
#  Name                                    :string
#  AccNumber                               :string
#  AccountId_Name                          :string
#  AccountId_CompanyId                     :string
#  AccountId_PhoneNumber                   :string
#  SaleStatusId_Name                       :string
#  CAPStatus_Name                          :string
#  PraiseTax                               :string
#  BookkeepingDate                         :datetime
#  AccountId_IsAccount                     :boolean
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  PraiseTaxNumber                         :integer
#  NextNote                                :datetime
#  WorkStatus_Name                         :string
#  FamilyStatus_Name                       :string
#  AdditionalSellers_Name                  :string
#  Number                                  :integer
#  AccountIsHanicapped_Name                :string
#  KidsUnder18_Name                        :string
#  LeadStatusId_Name                       :string
#  LeadStatusId_StateId                    :string
#  AcademicDetails                         :text
#  AlimonyDetails                          :text
#  ArmyDischargeDetails                    :text
#  DonationDetails                         :text
#  FamilyDisabilityDetails                 :text
#  HospitalDetails                         :text
#  ImmigrationCardDetails                  :text
#  NotWorkingDetails                       :text
#  PensionDepositDetails                   :text
#  PensionDetails                          :text
#  ReservesDetails                         :text
#  SecuritiesDetails                       :text
#  UnemploymentFeeDetails                  :text
#  HandicappedDetails                      :text
#  TaxType_Name                            :string
#  Campaign                                :string
#  AddressOfSale                           :string
#  AverageIncome                           :string
#  AverageIncomePartner                    :string
#  DivorceYear                             :string
#  YearOfSale                              :string
#  Lawyers_Name                            :string
#  Lawyers_Address                         :string
#  Lawyers_OwnerId                         :string
#  Lawyers_PhoneNumber                     :string
#  Lawyers_Description                     :text
#  Lawyers_OfficePhone                     :string
#  Lawyers_Email                           :string
#  Lawyers_LinkingFactor                   :string
#  Lawyers_Comment                         :text
#  Lawyers_StatusLaw                       :string
#  ChangedLeadToClient_username            :string
#  ChangedLeadToClient_email               :string
#  ChangedLeadToClient_name                :string
#  ChangedLeadToClient_active              :boolean
#  ChangedLeadToClient_extension           :string
#  ChangedLeadToClient_job                 :string
#  ChangedLeadToClient_phone               :string
#  ChangedLeadToClient_last_success_login  :datetime
#  LeadIrrelevantReason                    :string
#  FieldAgent                              :string
#  TaxType                                 :string
#  LeadStatusId                            :string
#  Clientconfidentiality                   :boolean
#  LeadOwnerId                             :string
#  ChangingLead                            :string
#  Lawyers                                 :string
#  ChangedLeadToClient                     :string
#  FamilyStatus                            :string
#  WorkStatus                              :string
#  YearOfSaleNew                           :string
#  AdditionalSellers                       :string
#  redemption                              :boolean
#  Futuresale                              :boolean
#  KidsUnder18                             :string
#  PropertyTypeSold                        :string
#  AccountIsHanicapped                     :string
#  accident                                :boolean
#  NeedPromotion                           :boolean
#  CAPStatus                               :string
#  Source                                  :string
#  OtherSource                             :string
#  Email                                   :string
#  City                                    :string
#  CompanyId                               :string
#  PhoneNumber                             :string
#  Address                                 :string
#  PhoneNumber2                            :string
#  Website                                 :string
#  Fax                                     :string
#  NumberOfHeirs                           :integer
#  Comment                                 :text
#  Documentation                           :text
#  IsAccount                               :boolean
#  DateBecomeCustomer                      :datetime
#  StatusId                                :string
#  DocStatus                               :string
#  Number2                                 :integer
#  updatedByTrigger                        :string
#  AdditionalAsset                         :string
#  SoldProperty6Years                      :string
#  createdBy                               :string
#  updatedBy                               :string
#

class Sale < ApplicationRecord
  include DecodeHtmlEntities
  has_many :external_details, foreign_key: :object_id, primary_key: :object_id
  has_many :accounting_headers, foreign_key: :object_id, primary_key: :objectId
end

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
#  all_extra_info                         :text
#  closing_date                           :datetime
#  cpa_chat                               :text
#  cpa_date                               :datetime
#  cpa_followup_date                      :datetime
#  createdBy                              :string
#  discount                               :decimal(10, 2)
#  discount_type                          :string
#  discount_value                         :decimal(10, 2)
#  est_refund                             :decimal(10, 2)
#  invoice_issued                         :boolean          default(FALSE)
#  lawyer_address                         :string
#  lawyer_comment                         :text
#  lawyer_description                     :text
#  lawyer_email                           :string
#  lawyer_linking_factor                  :string
#  lawyer_name                            :string
#  lawyer_office_phone                    :string
#  lawyer_phone_number                    :string
#  lawyer_status_law                      :string
#  next_step_date                         :datetime
#  objectId                               :string
#  owner_active                           :boolean
#  owner_extension                        :string
#  owner_job                              :string
#  owner_last_success_login               :datetime
#  owner_name                             :string
#  owner_phone                            :string
#  owner_username                         :string
#  pakid_shoma_name                       :string
#  redemption                             :boolean
#  refun_tax_made_date                    :datetime
#  sale_email                             :string
#  sale_landline                          :string
#  sale_mobile                            :string
#  sale_status_name                       :string
#  sale_status_probability                :integer
#  signed_sms                             :boolean          default(FALSE)
#  total                                  :decimal(10, 2)
#  total_before_discount                  :decimal(10, 2)
#  updatedBy                              :string
#  updatedByTrigger                       :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  cpa_name_id                            :string
#  cpa_owner_id                           :string
#  lawyer_id                              :string
#  lawyer_owner_id                        :string
#  owner_id                               :string
#  pakid_shoma_id                         :string
#  sale_status_id                         :string
#
# Indexes
#
#  index_sales_on_cpa_name_id     (cpa_name_id)
#  index_sales_on_cpa_owner_id    (cpa_owner_id)
#  index_sales_on_lawyer_id       (lawyer_id)
#  index_sales_on_objectId        (objectId) UNIQUE
#  index_sales_on_owner_id        (owner_id)
#  index_sales_on_pakid_shoma_id  (pakid_shoma_id)
#  index_sales_on_sale_status_id  (sale_status_id)
#
require "test_helper"

class SaleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

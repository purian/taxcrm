# == Schema Information
#
# Table name: sales
#
#  id                    :integer          not null, primary key
#  objectId              :string
#  Name                  :string
#  AccNumber             :string
#  AccountId_Name        :string
#  AccountId_CompanyId   :string
#  AccountId_PhoneNumber :string
#  SaleStatusId_Name     :string
#  CAPStatus_Name        :string
#  PraiseTax             :string
#  BookkeepingDate       :datetime
#  AccountId_IsAccount   :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  PraiseTaxNumber       :integer
#
class Sale < ApplicationRecord
  include DecodeHtmlEntities
  has_many :external_details, foreign_key: :object_id, primary_key: :object_id
  has_many :accounting_headers, foreign_key: :object_id, primary_key: :objectId
end

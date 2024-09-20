# == Schema Information
#
# Table name: clients
#
#  id                  :integer          not null, primary key
#  objectId            :string
#  Name                :string
#  Email               :string
#  PhoneNumber         :string
#  CellPhone           :string
#  Position            :string
#  AccountId_Name      :string
#  OwnerId_name        :string
#  AccountId_IsAccount :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  Number2             :string
#  Number              :string
#  CompanyId           :string
#  LeadOwnerId_name    :string
#  DateBecomeCustomer  :datetime
#  Documentation       :text
#  IsAccount           :boolean
#
class Client < ApplicationRecord
  include DecodeHtmlEntities

  has_many :time_lines, foreign_key: 'object_id_value'
end

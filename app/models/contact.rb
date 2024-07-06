# == Schema Information
#
# Table name: contacts
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
#
class Contact < ApplicationRecord
  include DecodeHtmlEntities
end

# == Schema Information
#
# Table name: contacts
#
#  id                  :integer          not null, primary key
#  AccountId_IsAccount :boolean
#  AccountId_Name      :string
#  CellPhone           :string
#  Email               :string
#  Name                :string
#  OwnerId_name        :string
#  PhoneNumber         :string
#  Position            :string
#  objectId            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_contacts_on_objectId  (objectId) UNIQUE
#
class Contact < ApplicationRecord
  include DecodeHtmlEntities
end

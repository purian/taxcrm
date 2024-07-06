# == Schema Information
#
# Table name: referrals
#
#  id             :integer          not null, primary key
#  objectId       :string
#  Name           :string
#  PhoneNumber    :string
#  OwnerId_name   :string
#  City_Name      :string
#  StatusLaw_Name :string
#  LinkingFactor  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Referral < ApplicationRecord
  include DecodeHtmlEntities
end

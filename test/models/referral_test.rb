# == Schema Information
#
# Table name: referrals
#
#  id             :integer          not null, primary key
#  City_Name      :string
#  LinkingFactor  :string
#  Name           :string
#  OwnerId_name   :string
#  PhoneNumber    :string
#  StatusLaw_Name :string
#  objectId       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_referrals_on_objectId  (objectId) UNIQUE
#
require "test_helper"

class ReferralTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

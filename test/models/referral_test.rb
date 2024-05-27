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
require "test_helper"

class ReferralTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

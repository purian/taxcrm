# == Schema Information
#
# Table name: personal_informations
#
#  id                :integer          not null, primary key
#  apartment_number  :string
#  ballot_box_number :integer
#  ballot_box_oid    :integer
#  campaign_oid      :integer
#  city_oid          :integer
#  deleted           :boolean
#  father_name       :string
#  first_name        :string
#  house_number      :string
#  last_name         :string
#  oid               :integer
#  street            :string
#  voter_number      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  voter_id          :integer
#
require "test_helper"

class PersonalInformationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

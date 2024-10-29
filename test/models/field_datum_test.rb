# == Schema Information
#
# Table name: field_data
#
#  id              :integer          not null, primary key
#  base64_content  :text
#  decoded_content :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class FieldDatumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

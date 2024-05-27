# == Schema Information
#
# Table name: leads
#
#  id                :integer          not null, primary key
#  objectId          :string
#  Name              :string
#  Email             :string
#  PhoneNumber       :string
#  LeadStatusId_Name :string
#  LeadOwnerId_name  :string
#  IsAccount         :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  CompanyId         :string
#  Number            :string
#  Documentation     :text
#  SourceList        :text
#  PraiseTax         :string
#  Lawyers_Name      :string
#
require "test_helper"

class LeadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

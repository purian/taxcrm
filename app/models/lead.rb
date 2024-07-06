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
class Lead < ApplicationRecord
  include DecodeHtmlEntities
end

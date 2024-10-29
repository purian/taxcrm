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
class FieldDatum < ApplicationRecord
end

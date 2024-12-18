# == Schema Information
#
# Table name: client_external_details
#
#  id                  :integer          not null, primary key
#  client_name         :string
#  client_number       :string
#  client_phone_number :string
#  sync_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :string
#
class ClientExternalDetail < ApplicationRecord
  validates :client_id, presence: true
  validates :client_number, presence: true
  validates :client_name, presence: true
  validates :client_phone_number, presence: true
end 

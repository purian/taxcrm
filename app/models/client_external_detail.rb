# == Schema Information
#
# Table name: client_external_details
#
#  id                  :integer          not null, primary key
#  client_name         :string
#  client_number       :string
#  client_phone_number :string
#  data_owner          :string
#  sync_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :string
#
# Indexes
#
#  index_client_external_details_on_number_phone_owner  (client_number,client_phone_number,data_owner) UNIQUE
#
class ClientExternalDetail < ApplicationRecord
  validates :client_id, presence: true
  validates :client_number, presence: true
  validates :client_name, presence: true
  validates :client_phone_number, presence: true
  validates :data_owner, presence: true
  
  # Add compound uniqueness validation
  validates :client_number, uniqueness: { 
    scope: [:client_phone_number, :data_owner],
    message: 'combination with phone number and data owner already exists' 
  }
end 

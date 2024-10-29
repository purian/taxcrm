# == Schema Information
#
# Table name: accounting_headers
#
#  id                  :integer          not null, primary key
#  doc_type_name       :string
#  document_date       :datetime
#  document_number     :integer
#  email               :string
#  external_created_at :datetime
#  external_updated_at :datetime
#  file_name           :string
#  file_private        :boolean
#  file_url            :string
#  name                :string
#  object_type         :string           not null
#  total_sum           :decimal(10, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  external_object_id  :string           not null
#  object_id           :string           not null
#
# Indexes
#
#  index_accounting_headers_on_external_object_id         (external_object_id) UNIQUE
#  index_accounting_headers_on_object_type_and_object_id  (object_type,object_id)
#
class AccountingHeader < ApplicationRecord
  belongs_to :lead, foreign_key: :object_id, primary_key: :objectId, optional: true
  belongs_to :client, foreign_key: :object_id, primary_key: :objectId, optional: true
  belongs_to :sale, foreign_key: :object_id, primary_key: :objectId, optional: true

  validates :object_id, :object_type, :external_object_id, presence: true
  validates :object_type, inclusion: { in: %w(Lead Client Sale) }
  validates :external_object_id, uniqueness: true

  before_validation :set_object_type

  private

  def set_object_type
    self.object_type = case
                       when lead
                         'Lead'
                       when client
                         'Client'
                       when sale
                         'Sale'
                       end
  end
end

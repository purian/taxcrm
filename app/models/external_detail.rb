# == Schema Information
#
# Table name: external_details
#
#  id           :integer          not null, primary key
#  comment      :string
#  is_valid     :boolean          default(TRUE)
#  object_type  :string           not null
#  phone_number :string
#  sync_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  object_id    :string           not null
#
# Indexes
#
#  index_external_details_on_object_id_and_object_type  (object_id,object_type)
#
class ExternalDetail < ApplicationRecord
  belongs_to :lead, foreign_key: :object_id, primary_key: :objectId, optional: true
  belongs_to :client, foreign_key: :object_id, primary_key: :objectId, optional: true
  belongs_to :sale, foreign_key: :object_id, primary_key: :objectId, optional: true

  validates :object_id, :object_type, presence: true
  validates :object_type, inclusion: { in: %w(Lead Client Sale) }
  validates :phone_number, presence: true, unless: :invalid_phone?

  before_validation :set_object_type

  private

  def invalid_phone?
    !is_valid || comment.present?
  end

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

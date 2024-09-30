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
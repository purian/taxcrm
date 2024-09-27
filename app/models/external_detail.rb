class ExternalDetail < ApplicationRecord
  belongs_to :lead, foreign_key: :object_id, primary_key: :object_id, optional: true
  belongs_to :client, foreign_key: :object_id, primary_key: :object_id, optional: true
  belongs_to :sale, foreign_key: :object_id, primary_key: :object_id, optional: true

  validates :object_id, :object_type, presence: true
  validates :object_type, inclusion: { in: %w(Lead Client Sale) }
  validates :phone_number, presence: true

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
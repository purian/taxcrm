
class ExternalDetail < ApplicationRecord
  belongs_to :object, polymorphic: true

  validates :phone_number, presence: true
end
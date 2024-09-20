# == Schema Information
#
# Table name: time_lines
#
#  id              :integer          not null, primary key
#  objectId        :string
#  event           :string
#  object_class    :string
#  object_id_value :string
#  name            :string
#  data            :jsonb
#  pinned          :boolean
#  last            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class TimeLine < ApplicationRecord
  serialize :data, JSON

  belongs_to :lead, foreign_key: 'object_id_value', optional: true
  belongs_to :client, foreign_key: 'object_id_value', optional: true
  belongs_to :sale, foreign_key: 'object_id_value', optional: true

  belongs_to :user, optional: true

  validates :event, presence: true
  validates :object_class, presence: true
  validates :object_id_value, presence: true

  before_save :set_name

  private

  def set_name
    case object_class
    when 'Sales'
      self.name = data['SaleName'] if data['SaleName'].present?
    when 'Accounts'
      self.name = data['AccountName'] if data['AccountName'].present?
    when 'Tasks'
      self.name = data['TaskName'] if data['TaskName'].present?
    end
  end
end
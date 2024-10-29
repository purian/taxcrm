# == Schema Information
#
# Table name: time_lines
#
#  id              :integer          not null, primary key
#  account_name    :string
#  data            :text
#  event           :string
#  last            :boolean
#  name            :string
#  objectId        :string
#  object_class    :string
#  object_id_value :string
#  pinned          :boolean
#  sale_name       :string
#  sale_total      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :string
#  sale_id         :string
#  sale_owner_id   :string
#  sale_status_id  :string
#  user_id         :string
#
# Indexes
#
#  index_time_lines_on_object_class     (object_class)
#  index_time_lines_on_object_id_value  (object_id_value)
#
class TimeLine < ApplicationRecord
  belongs_to :lead, foreign_key: 'object_id_value', optional: true
  belongs_to :client, foreign_key: 'object_id_value', optional: true
  belongs_to :sale, foreign_key: 'object_id_value', optional: true

  belongs_to :user, optional: true

  validates :event, presence: true
  validates :object_class, presence: true
  validates :object_id_value, presence: true

  before_save :set_name

  serialize :data, coder: JSON

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

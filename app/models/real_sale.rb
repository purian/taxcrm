# == Schema Information
#
# Table name: real_sales
#
#  id                       :integer          not null, primary key
#  all_extra_info           :text
#  closing_date             :datetime
#  cpa_chat                 :text
#  cpa_date                 :datetime
#  cpa_followup_date        :datetime
#  discount                 :decimal(10, 2)
#  discount_type            :string
#  discount_value           :decimal(10, 2)
#  est_refund               :decimal(10, 2)
#  invoice_issued           :boolean          default(FALSE)
#  lawyer_address           :string
#  lawyer_comment           :text
#  lawyer_description       :text
#  lawyer_email             :string
#  lawyer_linking_factor    :string
#  lawyer_name              :string
#  lawyer_office_phone      :string
#  lawyer_phone_number      :string
#  lawyer_status_law        :string
#  next_step_date           :datetime
#  owner_active             :boolean
#  owner_extension          :string
#  owner_job                :string
#  owner_last_success_login :datetime
#  owner_name               :string
#  owner_phone              :string
#  owner_username           :string
#  pakid_shoma_name         :string
#  refun_tax_made_date      :datetime
#  sale_email               :string
#  sale_landline            :string
#  sale_mobile              :string
#  sale_status_name         :string
#  sale_status_probability  :integer
#  signed_sms               :boolean          default(FALSE)
#  total                    :decimal(10, 2)
#  total_before_discount    :decimal(10, 2)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  cpa_name_id              :string
#  cpa_owner_id             :string
#  lawyer_id                :string
#  lawyer_owner_id          :string
#  owner_id                 :string
#  pakid_shoma_id           :string
#  sale_id                  :integer
#  sale_status_id           :string
#
# Indexes
#
#  index_real_sales_on_cpa_name_id     (cpa_name_id)
#  index_real_sales_on_cpa_owner_id    (cpa_owner_id)
#  index_real_sales_on_lawyer_id       (lawyer_id)
#  index_real_sales_on_owner_id        (owner_id)
#  index_real_sales_on_pakid_shoma_id  (pakid_shoma_id)
#  index_real_sales_on_sale_id         (sale_id)
#  index_real_sales_on_sale_status_id  (sale_status_id)
#
# Foreign Keys
#
#  sale_id  (sale_id => sales.id)
#
class RealSale < ApplicationRecord
  belongs_to :sale

  validates :sale, presence: true
end

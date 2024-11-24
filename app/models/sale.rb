# == Schema Information
#
# Table name: sales
#
#  id                                     :integer          not null, primary key
#  AcademicDetails                        :text
#  AccNumber                              :string
#  AccountId_CompanyId                    :string
#  AccountId_IsAccount                    :boolean
#  AccountId_Name                         :string
#  AccountId_PhoneNumber                  :string
#  AccountIsHanicapped                    :string
#  AccountIsHanicapped_Name               :string
#  AdditionalAsset                        :string
#  AdditionalSellers                      :string
#  AdditionalSellers_Name                 :string
#  Address                                :string
#  AddressOfSale                          :string
#  AlimonyDetails                         :text
#  ArmyDischargeDetails                   :text
#  AverageIncome                          :string
#  AverageIncomePartner                   :string
#  BookkeepingDate                        :datetime
#  CAPStatus                              :string
#  CAPStatus_Name                         :string
#  Campaign                               :string
#  ChangedLeadToClient                    :string
#  ChangedLeadToClient_active             :boolean
#  ChangedLeadToClient_email              :string
#  ChangedLeadToClient_extension          :string
#  ChangedLeadToClient_job                :string
#  ChangedLeadToClient_last_success_login :datetime
#  ChangedLeadToClient_name               :string
#  ChangedLeadToClient_phone              :string
#  ChangedLeadToClient_username           :string
#  ChangingLead                           :string
#  City                                   :string
#  Clientconfidentiality                  :boolean
#  Comment                                :text
#  CompanyId                              :string
#  DateBecomeCustomer                     :datetime
#  DivorceYear                            :string
#  DocStatus                              :string
#  Documentation                          :text
#  DonationDetails                        :text
#  Email                                  :string
#  FamilyDisabilityDetails                :text
#  FamilyStatus                           :string
#  FamilyStatus_Name                      :string
#  Fax                                    :string
#  FieldAgent                             :string
#  Futuresale                             :boolean
#  HandicappedDetails                     :text
#  HospitalDetails                        :text
#  ImmigrationCardDetails                 :text
#  IsAccount                              :boolean
#  KidsUnder18                            :string
#  KidsUnder18_Name                       :string
#  Lawyers                                :string
#  Lawyers_Address                        :string
#  Lawyers_Comment                        :text
#  Lawyers_Description                    :text
#  Lawyers_Email                          :string
#  Lawyers_LinkingFactor                  :string
#  Lawyers_Name                           :string
#  Lawyers_OfficePhone                    :string
#  Lawyers_OwnerId                        :string
#  Lawyers_PhoneNumber                    :string
#  Lawyers_StatusLaw                      :string
#  LeadIrrelevantReason                   :string
#  LeadOwnerId                            :string
#  LeadStatusId                           :string
#  LeadStatusId_Name                      :string
#  LeadStatusId_StateId                   :string
#  Name                                   :string
#  NeedPromotion                          :boolean
#  NextNote                               :datetime
#  NotWorkingDetails                      :text
#  Number                                 :integer
#  Number2                                :integer
#  NumberOfHeirs                          :integer
#  OtherSource                            :string
#  PensionDepositDetails                  :text
#  PensionDetails                         :text
#  PhoneNumber                            :string
#  PhoneNumber2                           :string
#  PraiseTax                              :string
#  PraiseTaxNumber                        :integer
#  PropertyTypeSold                       :string
#  ReservesDetails                        :text
#  SaleStatusId_Name                      :string
#  SecuritiesDetails                      :text
#  SoldProperty6Years                     :string
#  Source                                 :string
#  StatusId                               :string
#  TaxType                                :string
#  TaxType_Name                           :string
#  UnemploymentFeeDetails                 :text
#  Website                                :string
#  WorkStatus                             :string
#  WorkStatus_Name                        :string
#  YearOfSale                             :string
#  YearOfSaleNew                          :string
#  accident                               :boolean
#  all_extra_info                         :text
#  closing_date                           :datetime
#  cpa_chat                               :text
#  cpa_date                               :datetime
#  cpa_followup_date                      :datetime
#  createdBy                              :string
#  discount                               :decimal(10, 2)
#  discount_type                          :string
#  discount_value                         :decimal(10, 2)
#  est_refund                             :decimal(10, 2)
#  invoice_issued                         :boolean          default(FALSE)
#  lawyer_address                         :string
#  lawyer_comment                         :text
#  lawyer_description                     :text
#  lawyer_email                           :string
#  lawyer_linking_factor                  :string
#  lawyer_name                            :string
#  lawyer_office_phone                    :string
#  lawyer_phone_number                    :string
#  lawyer_status_law                      :string
#  next_step_date                         :datetime
#  objectId                               :string
#  owner_active                           :boolean
#  owner_extension                        :string
#  owner_job                              :string
#  owner_last_success_login               :datetime
#  owner_name                             :string
#  owner_phone                            :string
#  owner_username                         :string
#  pakid_shoma_name                       :string
#  redemption                             :boolean
#  refun_tax_made_date                    :datetime
#  sale_email                             :string
#  sale_landline                          :string
#  sale_mobile                            :string
#  sale_status_name                       :string
#  sale_status_probability                :integer
#  signed_sms                             :boolean          default(FALSE)
#  total                                  :decimal(10, 2)
#  total_before_discount                  :decimal(10, 2)
#  updatedBy                              :string
#  updatedByTrigger                       :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  cpa_name_id                            :string
#  cpa_owner_id                           :string
#  lawyer_id                              :string
#  lawyer_owner_id                        :string
#  owner_id                               :string
#  pakid_shoma_id                         :string
#  sale_status_id                         :string
#
# Indexes
#
#  index_sales_on_cpa_name_id     (cpa_name_id)
#  index_sales_on_cpa_owner_id    (cpa_owner_id)
#  index_sales_on_lawyer_id       (lawyer_id)
#  index_sales_on_objectId        (objectId) UNIQUE
#  index_sales_on_owner_id        (owner_id)
#  index_sales_on_pakid_shoma_id  (pakid_shoma_id)
#  index_sales_on_sale_status_id  (sale_status_id)
#
class Sale < ApplicationRecord
  include DecodeHtmlEntities
  has_many :external_details, foreign_key: :object_id, primary_key: :object_id
  has_many :accounting_headers, foreign_key: :object_id, primary_key: :objectId
  has_many :time_lines, foreign_key: 'object_id_value'
  has_many :real_sales

  HEADERS = {
    'accept' => '*/*',
    'accept-language' => 'en-US,en;q=0.9,he;q=0.8',
    'content-type' => 'text/plain',
    'dnt' => '1',
    'origin' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il',
    'referer' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il/',
    'sec-ch-ua' => '"Google Chrome";v="123", "Not:A-Brand";v="8", "Chromium";v="123"',
    'sec-ch-ua-mobile' => '?0',
    'sec-ch-ua-platform' => '"macOS"',
    'sec-fetch-dest' => 'empty',
    'sec-fetch-mode' => 'cors',
    'sec-fetch-site' => 'same-site',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36'
  }

  def update_details
    Rails.logger.info "Fetching details for sale #{objectId} at #{Time.now}"
    retries = 0
    begin
      response = HTTParty.post(
        'https://api-1.mbapps.co.il/parse/classes/Accounts',
        headers: Sale.request_headers.merge('priority' => 'u=1, i'),
        body: Sale.sale_detail_request_body(objectId).to_json
      )
      
      if response.parsed_response['results'].nil?
        error_message = "Unexpected response for sale #{objectId}: #{response.inspect}"
        Rails.logger.error error_message
        return false
      else
        sale_details = response.parsed_response['results'].first
        if sale_details
          Rails.logger.info "Updating sale #{objectId} with new details at #{Time.now}"
          update(Sale.prepare_sale_record(sale_details))
          return true
        else
          Rails.logger.warn "No details found for sale #{objectId} at #{Time.now}"
          return false
        end
      end
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      retries += 1
      if retries <= 10
        Rails.logger.warn "Attempt #{retries} failed for sale #{objectId}: #{e.message}. Retrying in 2 seconds..."
        sleep 2
        retry
      else
        Rails.logger.error "Failed to fetch details for sale #{objectId} after 10 attempts: #{e.message}"
        return false
      end
    rescue StandardError => e
      Rails.logger.error "Unexpected error for sale #{objectId}: #{e.message}"
      return false
    end
  end

  def update_accounting_headers
    Rails.logger.info "Fetching accounting headers for sale #{objectId} at #{Time.now}"
    retries = 0
    begin
      response = HTTParty.post(
        'https://api-1.mbapps.co.il/parse/classes/AccountingHeaders', 
        headers: Sale.request_headers, 
        body: Sale.accounting_headers_request_body(objectId).to_json
      )
      
      Sale.process_accounting_headers(response, self)
      return true
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      retries += 1
      if retries <= 10
        Rails.logger.warn "Attempt #{retries} failed for sale #{objectId}: #{e.message}. Retrying in 2 seconds..."
        sleep 2
        retry
      else
        Rails.logger.error "Failed to fetch accounting headers for sale #{objectId} after 10 attempts: #{e.message}"
        return false
      end
    rescue StandardError => e
      Rails.logger.error "Unexpected error for sale #{objectId}: #{e.message}"
      return false
    end
  end

  def process_timeline
    Sales::TimelineProcessorService.new(self).process
  end

  class << self
    def request_headers
      HEADERS.merge('X-Parse-Session-Token' => AuthenticationService.fetch_token('benamram119@walla.com', 'Guy@1986'))
    end

    def sale_detail_request_body(object_id)
      {
        where: { objectId: object_id },
        include: "LeadIrrelevantReason,FieldAgent,TaxType,LeadStatusId,Clientconfidentiality,LeadOwnerId,ChangingLead,Lawyers,ChangedLeadToClient,FamilyStatus,WorkStatus,YearOfSaleNew,AdditionalSellers,redemption,Futuresale,KidsUnder18,PropertyTypeSold,AccountIsHanicapped,accident,NeedPromotion,CAPStatus",
        limit: 1,
        _method: "GET",
        _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
        _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
        _ClientVersion: "js1.10.1",
        _InstallationId: "9f63e5c7-8d7c-fa3b-24af-f910a1560651",
        _SessionToken: AuthenticationService.fetch_token('benamram119@walla.com', 'Guy@1986')
      }
    end

    def accounting_headers_request_body(object_id)
      {
        where: { AccountId: { __type: "Pointer", className: "Accounts", objectId: object_id } },
        keys: "DocumentDate,DocumentNumber,DocTypeId.Name,Email,TotalSum,File,Name",
        limit: 100,
        order: "-DocumentDate",
        _method: "GET",
        _ApplicationId: "aaaaaaae3aac375841ec08b905439c3fa4316c3d",
        _JavaScriptKey: "6ee213f7b4e169caa819715ee046cded",
        _ClientVersion: "js1.10.1",
        _InstallationId: "9f63e5c7-8d7c-fa3b-24af-f910a1560651",
        _SessionToken: AuthenticationService.fetch_token('benamram119@walla.com', 'Guy@1986')
      }
    end

    def process_accounting_headers(response, sale)
      headers = response['results']
      headers.each do |header|
        AccountingHeader.find_or_initialize_by(external_object_id: header['objectId']).tap do |ah|
          ah.update!(
            object_id: sale.objectId,
            object_type: 'Sale',
            document_date: parse_date(header['DocumentDate']),
            document_number: header['DocumentNumber'],
            doc_type_name: safe_dig(header, 'DocTypeId', 'Name'),
            name: header['Name'],
            total_sum: header['TotalSum'],
            email: header['Email'],
            file_name: safe_dig(header, 'File', 'name'),
            file_url: safe_dig(header, 'File', 'url'),
            file_private: safe_dig(header, 'File', 'private'),
            external_created_at: parse_date(header['createdAt']),
            external_updated_at: parse_date(header['updatedAt'])
          )
        end
      end
    end

    def prepare_sale_record(record)
      {
        objectId: decode_html_entities(record['objectId']),
        Source: safe_dig(record, 'Source', 'objectId'),
        OtherSource: decode_html_entities(record['OtherSource']),
        LeadOwnerId: safe_dig(record, 'LeadOwnerId', 'objectId'),
        Name: decode_html_entities(record['Name']),
        Email: decode_html_entities(record['Email']),
        City: decode_html_entities(record['City']),
        CompanyId: decode_html_entities(record['CompanyId']),
        PhoneNumber: decode_html_entities(record['PhoneNumber']),
        Address: decode_html_entities(record['Address']),
        PhoneNumber2: decode_html_entities(record['PhoneNumber2']),
        Website: decode_html_entities(record['Website']),
        Fax: decode_html_entities(record['Fax']),
        WorkStatus: safe_dig(record, 'WorkStatus', 'Name'),
        FamilyStatus: safe_dig(record, 'FamilyStatus', 'Name'),
        SoldProperty6Years: safe_dig(record, 'SoldProperty6Years', 'objectId'),
        PropertyTypeSold: safe_dig(record, 'PropertyTypeSold', 'Name'),
        AdditionalSellers: safe_dig(record, 'AdditionalSellers', 'Name'),
        NumberOfHeirs: record['NumberOfHeirs'],
        AdditionalAsset: safe_dig(record, 'AdditionalAsset', 'objectId'),
        Comment: decode_html_entities(record['Comment']),
        Documentation: decode_html_entities(record['Documentation']),
        IsAccount: record['IsAccount'],
        Number: record['Number'],
        Number2: record['Number2'],
        StatusId: safe_dig(record, 'StatusId', 'objectId'),
        DocStatus: safe_dig(record, 'DocStatus', 'objectId'),
        Lawyers: safe_dig(record, 'Lawyers', 'Name'),
        LeadStatusId: safe_dig(record, 'LeadStatusId', 'objectId'),
        DateBecomeCustomer: parse_date(record['DateBecomeCustomer']),
        ChangedLeadToClient: safe_dig(record, 'ChangedLeadToClient', 'name'),
        created_at: parse_date(record['createdAt']),
        updated_at: parse_date(record['updatedAt'])
      }
    end

    def parse_date(date_hash)    
      if date_hash
        if date_hash['iso'].present?
          DateTime.parse(date_hash['iso']) 
        else
          DateTime.parse(date_hash)
        end
      end
    end

    def safe_dig(hash, *keys)
      keys.reduce(hash) do |acc, key|
        acc.is_a?(Hash) ? (acc[key] || acc[key.to_s]) : nil
      end
    end

    def decode_html_entities(value)
      CGI.unescapeHTML(value.to_s) unless value.nil?
    end
  end
end

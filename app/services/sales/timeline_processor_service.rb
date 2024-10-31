module Sales
  class TimelineProcessorService
    include HTTParty
    base_uri 'https://api-4.mbapps.co.il'

    DELAY_BETWEEN_REQUESTS = 3 # seconds
    MAX_RETRIES = 3
    RETRY_DELAY = 300 
    DEBUG = ENV['DEBUG'].present?# seconds when hitting rate limit

    def initialize(sale)
      @sale = sale
      @retry_count = 0
      authenticate!
    end

    def process
      timeline_data = fetch_timeline_data
      process_sales_from_timeline(timeline_data)
    end

    private

    def debug_log(message, data = nil)
      return unless DEBUG

      puts "\n#{'=' * 80}"
      puts "#{Time.current.strftime('%H:%M:%S')} - [TimelineProcessor Debug] #{message}"
      
      if data.present?
        puts "-" * 40
        begin
          case data
          when String
            puts data
          when Hash, Array
            # Handle nested date objects specially
            formatted_data = JSON.pretty_generate(data)
            puts formatted_data
          when ActiveRecord::Base
            # For ActiveRecord objects, show attributes in a readable format
            puts JSON.pretty_generate(data.attributes)
          when ActiveModel::Errors
            # For validation errors
            puts data.full_messages.join("\n")
          else
            # Fallback for other types
            puts data.inspect
          end
        rescue => e
          puts "Error formatting debug data: #{e.message}"
          puts data.inspect
        end
      end
      
      puts "#{'=' * 80}\n"
    end
    def fetch_timeline_data
      begin
        sleep(DELAY_BETWEEN_REQUESTS) # Add delay before each request
        response = self.class.post('/parse/classes/_Timeline',
          headers: auth_headers,
          body: timeline_request_body.to_json
        )
        
        if response.code == 429 # Too Many Requests
          handle_rate_limit
        else
          handle_response(response)
        end
      rescue => e
        if @retry_count < MAX_RETRIES
          @retry_count += 1
          sleep(RETRY_DELAY)
          retry
        else
          raise e
        end
      end
    end

    def handle_rate_limit
      if @retry_count < MAX_RETRIES
        @retry_count += 1
        sleep(RETRY_DELAY)
        fetch_timeline_data # Retry the request
      else
        raise ApiError, "Rate limit exceeded after #{MAX_RETRIES} retries"
      end
    end

    def authenticate!
      email = 'benamram119@walla.com'
      password = 'Gg198666'
      @token = AuthenticationService.fetch_token(email, password)
    end

    def auth_headers
      {
        'accept' => '*/*',
        'content-type' => 'text/plain',
        'origin' => 'https://4ec54f4a-7ce0-3162-b9ad-3a7e4881d01f.mbapps.co.il',
        'X-Parse-Session-Token' => @token
      }
    end

    def auth_params
      {
        _ApplicationId: 'aaaaaaae3aac375841ec08b905439c3fa4316c3d',
        _JavaScriptKey: '6ee213f7b4e169caa819715ee046cded',
        _ClientVersion: 'js1.10.1',
        _InstallationId: '9f63e5c7-8d7c-fa3b-24af-f910a1560651',
        _SessionToken: @token
      }
    end

    def fetch_sale_details(sale_id)
      response = self.class.post('/parse/classes/Sales',
        headers: auth_headers,
        body: sale_details_request_body(sale_id).to_json
      )
      
      handle_response(response)
    end

    def timeline_request_body
      {
        where: {
          AccountId: {
            __type: "Pointer",
            className: "Accounts",
            objectId: @sale.objectId
          },
          "$or": [
            { Pinned: true },
            { Last: true }
          ]
        },
        include: "user,NotePrivateFile,ActivityI,ActivityId,ActivityTypeId,AccountId,EmailI,PriceQuoteI,PriceQuoteStatusId,SMSI,CaseId,CaseTypeId,CasePriorityId,CaseStatusId,ContactId,TaskId,TaskTypeId,SaleId,SaleStatusId",
        limit: 10,
        order: "-Pinned,-createdAt",
        _method: "GET"
      }.merge(auth_params)
    end

    def sale_details_request_body(sale_id)
      {
        where: { objectId: sale_id },
        include: "SaleStatusId,InsuranceMoneyInPast6Years,AccountId,CustomerQuality,SaleFamilyStatus,IsHandicapped,YearOfSaleNew,OwnerId,CAPStatus,PakidShoma,LawyerCommision,SalesRepComission,CPAName,Norefundreason,DocStatus,Lawyer,CollectionPercentages,InsuranceMoney",
        limit: 1,
        _method: "GET"
      }.merge(auth_params)
    end

    def handle_response(response)
      return JSON.parse(response.body) if response.success?

      Rails.logger.error("Timeline API Error: #{response.code} - #{response.body}")
      raise ApiError, "API request failed with status #{response.code}: #{response.body}"
    end

    def process_sales_from_timeline(timeline_data)
      timeline_data['results'].each do |item|
        next unless item['objectClass'] == 'Sales'
        
        sale_details = fetch_sale_details(item['objectIdValue'])
        create_real_sale(item, sale_details['results'].first) if sale_details['results'].any?
      end
    end

    def create_real_sale(timeline_item, sale_data)
      debug_log("Creating/Updating real sale with data:", sale_data)

      real_sale = @sale.real_sales.find_or_initialize_by(objectId: sale_data['objectId'])
      
      attributes = {
        # Existing fields remain unchanged
        closing_date: parse_date(sale_data.dig('ClosingDate', 'iso')),
        cpa_date: parse_date(sale_data.dig('CPADate', 'iso')),
        cpa_followup_date: parse_date(sale_data.dig('CPAFollowupDate', 'iso')),
        next_step_date: parse_date(sale_data.dig('NextStepDate', 'iso')),
        refun_tax_made_date: nil,
        cpa_name_id: sale_data.dig('CPAName', 'objectId'),
        cpa_owner_id: sale_data.dig('CpaOwnerId', 'objectId'),
        owner_id: sale_data.dig('OwnerId', 'objectId'),
        owner_username: sale_data.dig('OwnerId', 'username'),
        owner_name: sale_data.dig('OwnerId', 'name'),
        owner_active: sale_data.dig('OwnerId', 'active'),
        owner_job: sale_data.dig('OwnerId', 'job'),
        owner_phone: sale_data.dig('OwnerId', 'phone'),
        owner_extension: sale_data.dig('OwnerId', 'extension'),
        owner_last_success_login: parse_date(sale_data.dig('OwnerId', 'last_success_login', 'iso')),
        sale_email: sale_data['SaleEmail'],
        sale_landline: sale_data['SaleLandline'],
        sale_mobile: sale_data['SaleMobile'],
        total: sale_data['Total'],
        total_before_discount: sale_data['TotalBeforeDiscount'],
        discount: nil,
        discount_type: sale_data['DiscountType'],
        discount_value: sale_data['DiscountValue'],
        est_refund: sale_data['EstRefund'],
        invoice_issued: sale_data['InvoiceIssued'] || false,
        cpa_chat: sale_data['CPAChat'],
        all_extra_info: sale_data['AllExtraInfo'],
        pakid_shoma_id: sale_data.dig('PakidShoma', 'objectId'),
        pakid_shoma_name: sale_data.dig('PakidShoma', 'Name'),
        signed_sms: sale_data['SignedSMS'] || false,
        lawyer_id: sale_data.dig('Lawyer', 'objectId'),
        lawyer_name: sale_data.dig('Lawyer', 'Name'),
        lawyer_address: sale_data.dig('Lawyer', 'Address'),
        lawyer_owner_id: sale_data.dig('Lawyer', 'OwnerId', 'objectId'),
        lawyer_phone_number: sale_data.dig('Lawyer', 'PhoneNumber'),
        lawyer_description: sale_data.dig('Lawyer', 'Description'),
        lawyer_office_phone: sale_data.dig('Lawyer', 'OfficePhone'),
        lawyer_email: sale_data.dig('Lawyer', 'Email'),
        lawyer_linking_factor: sale_data.dig('Lawyer', 'LinkingFactor'),
        lawyer_comment: sale_data.dig('Lawyer', 'Comment'),
        lawyer_status_law: sale_data.dig('Lawyer', 'StatusLaw', 'objectId'),
        sale_status_id: sale_data.dig('SaleStatusId', 'objectId'),
        sale_status_name: sale_data.dig('SaleStatusId', 'Name'),
        sale_status_probability: sale_data.dig('SaleStatusId', 'Probability'),

        # New fields
        account_comment: sale_data['AccountComment'],
        cpa_name_text: sale_data.dig('CPAName', 'Name'),
        cap_status_name: sale_data.dig('CAPStatus', 'Name'),
        submission_date: parse_date(sale_data.dig('SubmissionDate', 'iso')),
        
        objectIdValue: timeline_item['objectIdValue']
      }

      debug_log("Attributes to be assigned:", attributes)
      real_sale.assign_attributes(attributes)
      
      if real_sale.changed?
        debug_log("Changed attributes:", real_sale.changes)
        real_sale.save!
        debug_log("Real sale saved successfully")
      else
        debug_log("No changes detected for real sale")
      end

      real_sale
    end

    def parse_date(date_string)
      Date.parse(date_string) if date_string.present?
    end
  end
end

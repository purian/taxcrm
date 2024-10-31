module Sales
  class TimelineProcessorService
    include HTTParty
    base_uri 'https://api-4.mbapps.co.il'

    DELAY_BETWEEN_REQUESTS = 3 # seconds
    MAX_RETRIES = 3
    RETRY_DELAY = 300 # seconds when hitting rate limit

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
      @sale.real_sales.find_or_create_by(
        sale_id: @sale.id,
        objectIdValue: timeline_item['objectIdValue']
      ) do |real_sale|
        real_sale.objectId = sale_data['objectId']
        
        # Existing fields
        real_sale.closing_date = parse_date(sale_data.dig('ClosingDate', 'iso'))
        real_sale.cpa_date = parse_date(sale_data.dig('CPADate', 'iso'))
        real_sale.cpa_followup_date = parse_date(sale_data.dig('CPAFollowupDate', 'iso'))
        real_sale.next_step_date = parse_date(sale_data.dig('NextStepDate', 'iso'))
        
        # CPA and Sales related
        real_sale.cpa_name_id = sale_data.dig('CPAName', 'objectId')
        real_sale.cpa_owner_id = sale_data.dig('CpaOwnerId', 'objectId')
        real_sale.owner_id = sale_data.dig('OwnerId', 'objectId')
        real_sale.owner_username = sale_data.dig('OwnerId', 'username')
        
        # Sale status details
        real_sale.sale_status_id = sale_data.dig('SaleStatusId', 'objectId')
        real_sale.sale_status_name = sale_data.dig('SaleStatusId', 'Name')
        real_sale.sale_status_probability = sale_data.dig('SaleStatusId', 'Probability')
        
        # ... other fields mapping
      end
    end

    def parse_date(date_string)
      Date.parse(date_string) if date_string.present?
    end
  end
end

module Sales
  class TimelineProcessorService
    include HTTParty
    base_uri 'https://api-4.mbapps.co.il'

    MAX_RETRIES = 3

    def initialize(sale)
      @sale = sale
      @retry_count = 0
      authenticate!
    end

    def process
      timeline_data = fetch_timeline_data
      process_sales_from_timeline(timeline_data)
    rescue => e
      if e.message.include?('text') && @retry_count < MAX_RETRIES
        @retry_count += 1
        authenticate!
        retry
      else
        raise e
      end
    end

    private

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

    def fetch_timeline_data
      response = self.class.post('/parse/classes/_Timeline',
        headers: auth_headers,
        body: timeline_request_body.to_json
      )
      
      handle_response(response)
    rescue => e
      if @retry_count < MAX_RETRIES
        @retry_count += 1
        authenticate!
        retry
      else
        raise e
      end
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
      @sale.real_sales.create!(
        objectId: sale_data['objectId'],
        objectIdValue: timeline_item['objectIdValue'],
        
        # Existing fields
        closing_date: parse_date(sale_data.dig('ClosingDate', 'iso')),
        cpa_date: parse_date(sale_data.dig('CPADate', 'iso')),
        cpa_followup_date: parse_date(sale_data.dig('CPAFollowupDate', 'iso')),
        next_step_date: parse_date(sale_data.dig('NextStepDate', 'iso')),
        
        # CPA and Sales related
        cpa_name_id: sale_data.dig('CPAName', 'objectId'),
        cpa_owner_id: sale_data.dig('CpaOwnerId', 'objectId'),
        owner_id: sale_data.dig('OwnerId', 'objectId'),
        owner_username: sale_data.dig('OwnerId', 'username'),
        
        # Sale status details
        sale_status_id: sale_data.dig('SaleStatusId', 'objectId'),
        sale_status_name: sale_data.dig('SaleStatusId', 'Name'),
        sale_status_probability: sale_data.dig('SaleStatusId', 'Probability'),
        
        # ... other fields mapping
      )
    end

    def parse_date(date_string)
      Date.parse(date_string) if date_string.present?
    end
  end
end

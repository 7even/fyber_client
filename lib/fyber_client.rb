require 'faraday'
require 'faraday_middleware/parse_oj'

require_relative 'fyber_client/params'
require_relative 'fyber_client/offer'

module FyberClient
  class << self
    BASE_URL = 'http://api.sponsorpay.com/feed/v1'.freeze
    
    def get(params)
      response = connection.get('offers.json', params.to_h)

      if response.status == 200
        response.body.fetch(:offers).map do |offer_attributes|
          Offer.new(offer_attributes)
        end
      else
        raise APIError, "Fyber responded with #{response.status} (#{response.body})"
      end
    end
    
  private
    def connection
      @connection ||= Faraday.new(BASE_URL) do |builder|
        builder.response :oj
        builder.adapter  Faraday.default_adapter
      end
    end
  end
  
  class APIError < StandardError; end
end

require 'faraday'
require 'faraday_middleware/parse_oj'

require_relative 'fyber_client/params'
require_relative 'fyber_client/offer'

module FyberClient
  class << self
    BASE_URL = 'http://api.sponsorpay.com/feed/v1'.freeze
    
    def get(params)
      response = connection.get('offers.json', params)

      if response.status != 200
        raise APIError, "Fyber responded with #{response.status} (#{response.body})"
      elsif response_valid?(response)
        response.body.fetch(:offers).map do |offer_attributes|
          Offer.new(offer_attributes)
        end
      else
        raise SignatureMismatch
      end
    end
    
  private
    def response_valid?(response)
      signature = Digest::SHA1.hexdigest(response.env[:raw_body] + ENV['API_KEY'])
      signature == response.headers['X-Sponsorpay-Response-Signature']
    end
    
    def connection
      @connection ||= Faraday.new(BASE_URL) do |builder|
        builder.response :oj, preserve_raw: true
        builder.adapter  Faraday.default_adapter
      end
    end
  end
  
  class APIError < StandardError; end
  class SignatureMismatch < APIError; end
end

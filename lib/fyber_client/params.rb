module FyberClient
  class Params
    IMPLICIT_PARAMS = {
      appid:       ENV['APPID'],
      format:      ENV['FORMAT'],
      ip:          ENV['IP'],
      locale:      ENV['LOCALE'],
      device_id:   ENV['DEVICE_ID'],
      offer_types: ENV['OFFER_TYPES']
    }.freeze
    
    attr_reader :params
    
    def initialize(explicit_params)
      @params = IMPLICIT_PARAMS.merge(explicit_params).merge(timestamp_param)
    end
    
    def to_h
      params.merge(hashkey: hashkey)
    end

    def each(&block)
      to_h.each(&block)
    end
    
  private
    def hashkey
      parts = params.map { |key, value| "#{key}=#{value}" }.sort
      parts << ENV['API_KEY']
      
      Digest::SHA1.hexdigest(parts.join('&'))
    end
    
    def timestamp_param
      { timestamp: Time.now.to_i }
    end
  end
end

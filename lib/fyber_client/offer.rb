module FyberClient
  class Offer
    attr_reader :title, :thumbnail, :payout
    
    def initialize(attributes)
      @title     = attributes.fetch(:title)
      @thumbnail = attributes.fetch(:thumbnail).fetch(:lowres)
      @payout    = attributes.fetch(:payout)
    end
  end
end

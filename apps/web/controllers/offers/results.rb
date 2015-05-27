module Web::Controllers::Offers
  class Results
    include Web::Action
    
    expose :offers
    
    def call(params)
      fyber_params = FyberClient::Params.new(params)
      @offers = FyberClient.get(fyber_params)
    end
  end
end

RSpec.describe FyberClient do
  describe '.get' do
    let(:response_headers) do
      { 'X-Sponsorpay-Response-Signature' => '6fe19527807c7067d29d05757c331c415c80aacb' }
    end
    
    let(:response_body) do
      Oj.dump(
        message: 'Ok',
        offers: [
          {
            title: 'Some title',
            thumbnail: {
              lowres: 'http://example.com/lowres.jpg',
              hires:  'http://example.com/hires.jpg'
            },
            payout: 12345
          }
        ]
      )
    end
    
    before(:each) do
      connection = Faraday.new do |builder|
        builder.response :oj, preserve_raw: true
        builder.adapter  :test do |stub|
          stub.get('offers.json') do
            [200, response_headers, response_body]
          end
        end
      end
      
      allow(subject).to receive(:connection).and_return(connection)
    end
    
    let(:params) do
      { uid: '7even', pub0: 'campaign2', page: 1 }
    end
    
    it 'calls Fyber with the passed params' do
      offer, * = subject.get(params)
      
      expect(offer.title).to eq('Some title')
      expect(offer.thumbnail).to eq('http://example.com/lowres.jpg')
      expect(offer.payout).to eq(12345)
    end
    
    context 'with an incorrect signature' do
      let(:response_headers) do
        {
          'X-Sponsorpay-Response-Signature' => '6fe19527807c7067d29d05757c331c415c80aaef'
        }
      end
      
      it 'raises a SignatureMismatch exception' do
        expect {
          subject.get(params)
        }.to raise_error(FyberClient::SignatureMismatch)
      end
    end
  end
end

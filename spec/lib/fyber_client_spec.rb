RSpec.describe FyberClient do
  describe '.get' do
    before(:each) do
      connection = Faraday.new do |builder|
        builder.response :oj
        builder.adapter  :test do |stub|
          stub.get('offers.json') do
            [200, {}, Oj.dump(message: 'Ok', offers: [])]
          end
        end
      end
      
      allow(subject).to receive(:connection).and_return(connection)
    end
    
    let(:params) do
      { uid: '7even', pub0: 'campaign2', page: 1 }
    end
    
    it 'calls Fyber with the passed params' do
      expect(subject.get(params)).to eq(message: 'Ok', offers: [])
    end
  end
end

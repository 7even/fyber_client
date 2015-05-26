RSpec.describe FyberClient::Params do
  subject { described_class.new(uid: '7even', pub0: 'campaign2', page: 1) }
  
  describe '#to_h' do
    before(:each) do
      allow(Time).to receive(:now).and_return(Time.at(123))
    end
    
    it 'returns a full hash of parameters' do
      expect(subject.to_h).to eq(
        appid:       '123',
        format:      'json',
        ip:          '8.8.8.8',
        locale:      'de',
        device_id:   '12345abcde',
        offer_types: '112',
        uid:         '7even',
        pub0:        'campaign2',
        page:        1,
        timestamp:   123,
        hashkey:     'ab16cd5cdf5ca3e35ee02f2be4945aa94b558fd9'
      )
    end
  end
end

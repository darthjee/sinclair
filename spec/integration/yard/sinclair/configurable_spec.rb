# frozen_string_literal: true

describe Sinclair::Configurable do
  describe '#yard' do
    before do
      MyConfigurable.configure do
        host 'interstella.com'
        port 5555
      end
    end

    after do
      MyConfigurable.reset_config
    end

    it 'sets right value for config host' do
      expect(MyConfigurable.config.host)
        .to eq('interstella.com')
    end

    it 'sets right value for config port' do
      expect(MyConfigurable.config.port)
        .to eq(5555)
    end

    context 'when reset_config is called' do
      before { MyConfigurable.reset_config }

      it 'returns initial value for host' do
        expect(MyConfigurable.config.host)
          .to be_nil
      end
    end
  end
end

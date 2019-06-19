# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Configurable do
  context 'when it is configured' do
    before do
      MyConfigurable.configure do |config|
        config.host 'interstella.art'
        config.port 5555
      end
    end

    after do
      MyConfigurable.reset_config
    end

    it 'sets configuration host' do
      expect(MyConfigurable.config.host)
        .to eq('interstella.art')
    end

    it 'sets configuration port' do
      expect(MyConfigurable.config.port)
        .to eq(5555)
    end

    context 'when #rest_config is called' do
      before do
        MyConfigurable.reset_config
      end

      it 'resets configuration host' do
        expect(MyConfigurable.config.host)
          .to be_nil
      end

      it 'resets configuration port' do
        expect(MyConfigurable.config.port).to eq(80)
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigClass do
  describe 'yard' do
    describe '.add_configs' do
      it 'Adding configurations to config class' do
        config = AppConfig.new

        expect(config.secret).to be_nil
        expect(config.app_name).to eq('MyApp')

        config_builder = Sinclair::ConfigBuilder.new(config)

        config_builder.secret '123abc'
        config_builder.app_name 'MySuperApp'

        expect(config.secret).to eq('123abc')
        expect(config.app_name).to eq('MySuperApp')
      end
    end
  end
end

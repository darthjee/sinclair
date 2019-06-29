# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigClass do
  describe 'yard' do
    describe '.add_configs' do
      subject(:config) { AppConfig.new }

      it 'has a secret configuration method' do
        expect(config.secret).to be_nil
      end

      it 'has a app_name configuration method' do
        expect(config.app_name).to eq('MyApp')
      end

      context 'when configured' do
        let(:config_builder) do
          Sinclair::ConfigBuilder.new(config)
        end

        before do
          config_builder.secret '123abc'
          config_builder.app_name 'MySuperApp'
        end

        it 'has a secret configuration method' do
          expect(config.secret).to eq('123abc')
        end

        it 'has a app_name configuration method' do
          expect(config.app_name).to eq('MySuperApp')
        end
      end
    end
  end
end

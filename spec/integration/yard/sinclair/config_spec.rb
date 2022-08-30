# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Config do
  describe 'yard' do
    describe '#to_hash' do
      subject(:config) { config_class.new }

      let(:config_class) { LoginConfig }

      it 'returns all configs hash' do
        expect(config.to_hash)
          .to eq('password' => nil, 'username' => 'bob')
      end

      it 'returns all configs hash on as_json calls' do
        expect(config.as_json)
          .to eq('password' => nil, 'username' => 'bob')
      end

      it 'returns all configs json on to_json calls' do
        expect(config.to_json)
          .to eq('{"password":null,"username":"bob"}')
      end
    end

    describe '#options' do
      subject(:config) { configurable.config }

      let(:configurable) { LoginConfigurable }

      before do
        LoginConfigurable.configure do |conf|
          conf.username :some_username
          conf.password :some_password
        end
      end

      it 'returns options with correct values' do
        expect(config.options.username).to eq(:some_username)
        expect(config.options.password).to eq(:some_password)
      end
    end
  end
end

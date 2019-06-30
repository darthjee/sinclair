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
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Config do
  subject(:child_klass) { Class.new(klass) }
  subject(:klass) { Class.new(described_class) }
  subject(:config) { klass.new }

  describe '.add_attributes' do
    it_behaves_like 'a config class with .add_attributes method'
  end

  describe 'attributes' do
    it_behaves_like 'a config class with .attributes method'
  end

  describe '#to_hash' do
    it 'returns empty hash' do
      expect(config.as_json).to eq({})
    end

    context 'when attributes have been defined' do
      before do
        klass.add_attributes(:username, :password)
        klass.attr_reader(:username, :password)
      end

      it 'uses given attributes to create json' do
        expect(config.as_json).to eq({
          'username' => nil, 'password' => nil
        })
      end

      context 'when the method called sets instance variable' do
        it 'returns the value' do
        end
      end
    end
  end
end

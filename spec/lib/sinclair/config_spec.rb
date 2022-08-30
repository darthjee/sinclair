# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Config do
  subject(:config) { klass.new }

  let(:child_klass) { Class.new(klass) }

  let(:klass) { Class.new(described_class) }

  describe '.config_attributes' do
    it_behaves_like 'a config class with .config_attributes method'
  end

  describe '.add_configs' do
    it_behaves_like 'a config class with .add_configs method'
  end

  describe '#to_hash' do
    it 'returns empty hash' do
      expect(config.as_json).to eq({})
    end

    context 'when attributes have been defined' do
      before do
        klass.config_attributes(:username, :password)
        klass.attr_reader(:username, :password)
      end

      it 'uses given attributes to create json' do
        expect(config.as_json)
          .to eq('username' => nil, 'password' => nil)
      end

      context 'when the method called sets instance variable' do
        before do
          klass.add_configs(name: 'John')
        end

        it 'returns the value' do
          expect(config.as_json).to eq(
            'name' => 'John', 'username' => nil, 'password' => nil
          )
        end
      end
    end

    context 'when passing options' do
      before do
        klass.add_configs(username: 'john', password: '123456')
      end

      it 'accpes only option' do
        expect(config.as_json(only: 'username'))
          .to eq('username' => 'john')
      end

      it 'accepts except options' do
        expect(config.as_json(except: 'password'))
          .to eq('username' => 'john')
      end
    end
  end

  describe '#to_json' do
    it 'returns empty json' do
      expect(config.to_json).to eq('{}')
    end

    context 'when attributes have been defined' do
      before do
        klass.config_attributes(:username, :password)
        klass.attr_reader(:username, :password)
      end

      it 'uses given attributes to create json' do
        expect(config.to_json)
          .to eq('{"username":null,"password":null}')
      end

      context 'when the method called sets instance variable' do
        before do
          klass.add_configs(name: 'John')
        end

        it 'returns the value' do
          expect(config.to_json).to eq(
            '{"username":null,"password":null,"name":"John"}'
          )
        end
      end
    end

    context 'when passing options' do
      before do
        klass.add_configs(username: 'john', password: '123456')
      end

      it 'accpes only option' do
        expect(config.to_json(only: 'username'))
          .to eq('{"username":"john"}')
      end

      it 'accepts except options' do
        expect(config.to_json(except: 'password'))
          .to eq('{"username":"john"}')
      end
    end
  end

  describe '#default_options' do
    before do
      klass.add_configs(:password, username: :user)
    end

    it do
      expect(config.default_options).to be_a(Sinclair::Options)
    end

    it 'returns an option with default values' do
      expect(config.default_options)
        .to eq(klass.options_class.new(username: :user, password: nil))
    end
  end
end

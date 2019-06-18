# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigFactory::MethodsBuilder do
  describe '#build' do
    let(:config_class) { Class.new(Sinclair::Config) }
    let(:config)       { config_class.new }
    let(:code_block)   { proc { builder.build } }

    let(:setter_block) do
      proc do |value|
        config.instance_variable_set(:@name, value)
      end
    end

    context 'when not initializing defaults' do
      subject(:builder) { described_class.new(config_class, :name, 'password') }

      it_behaves_like 'a config methods builder adding config'
    end

    context 'when initializing defaults' do
      subject(:builder) do
        described_class.new(
          config_class, name: 'Bobby', 'password' => 'abcdef'
        )
      end

      it_behaves_like 'a config methods builder adding config'
    end

    context 'when mixing names and hash' do
      subject(:builder) do
        described_class.new(
          config_class, :name, 'password' => 'abcdef'
        )
      end

      it_behaves_like 'a config methods builder adding config'

      context 'when name and hash define same config' do
        subject(:builder) do
          described_class.new(
            config_class, :name, name: 'abcdef'
          )
        end

        it_behaves_like 'a config methods builder adding config'
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigFactory::MethodsBuilder do
  describe '#build' do
    let(:config_class) { Class.new(Sinclair::Config) }
    let(:config)       { config_class.new }

    context 'when not initializing defaults' do
      subject(:builder) { described_class.new(config_class, :name, "password") }

      it_behaves_like 'a config methods builder adding config' do
        let(:code_block) { proc { builder.build } }
      end
    end

    context 'when initializing defaults' do
      subject(:builder) do
        described_class.new(
          config_class, name: 'Bobby', 'password' => 'abcdef'
        )
      end

      it_behaves_like 'a config methods builder adding config' do
        let(:code_block) { proc { builder.build } }
      end
    end
  end
end

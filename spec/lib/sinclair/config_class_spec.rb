# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigClass do
  subject(:klass) do
    Class.new { extend Sinclair::ConfigClass }
  end

  let(:child_klass) { Class.new(klass) }

  let(:config)      { klass.new }

  describe '.add_attributes' do
    it_behaves_like 'a config class with .add_attributes method'
  end

  describe 'attributes' do
    it_behaves_like 'a config class with .attributes method'
  end

  describe '.add_configs' do
    let(:setter_block) do
      proc { |value| config.instance_variable_set(:@name, value) }
    end

    it_behaves_like 'a config methods builder adding config' do
      let(:code_block) { proc { klass.add_configs(:name) } }

      it 'sets nil value by default' do
        code_block.call
        expect(config.name).to be_nil
      end

      it 'adds attributes to class' do
        expect(&code_block).to change(klass, :attributes)
          .from([]).to(%i[name])
      end
    end

    context 'when giving defaults' do
      it_behaves_like 'a config methods builder adding config' do
        let(:code_block) { proc { klass.add_configs(name: 'Bob') } }

        it 'sets default value' do
          code_block.call
          expect(config.name).to eq('Bob')
        end

        it 'adds attributes to class' do
          expect(&code_block).to change(klass, :attributes)
            .from([]).to(%i[name])
        end
      end
    end
  end
end

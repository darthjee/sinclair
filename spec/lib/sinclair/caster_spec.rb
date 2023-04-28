# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Caster do
  subject(:caster) { caster_class.new(&method_name) }

  let(:caster_class) { Class.new(described_class) }

  describe '.cast' do
    context 'when no options are given and the block requires none' do
      let(:method_name) { :to_s }

      it 'uses the block to transform the value' do
        expect(caster.cast(10)).to eq('10')
      end
    end

    context 'when options are given and the block requires none' do
      let(:method_name) { :to_i }

      it 'uses the block to transform the value' do
        expect(caster.cast('10', extra: true)).to eq(10)
      end
    end
  end
end

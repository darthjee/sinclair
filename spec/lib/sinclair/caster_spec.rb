# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Caster do
  subject(:caster) { caster_class.new(&method_name) }

  let(:caster_class) { Class.new(described_class) }

  describe '.cast' do
    context 'when no options are given and the block accepts none' do
      let(:method_name) { :to_s }

      it 'uses the block to transform the value' do
        expect(caster.cast(10)).to eq('10')
      end
    end

    context 'when options are given and the block accepts none' do
      let(:method_name) { :to_i }

      it 'uses the block to transform the value' do
        expect(caster.cast('10', extra: true)).to eq(10)
      end
    end

    context 'when no options are given and the block accepts options' do
      subject(:caster) do
        caster_class.new do |value, sum: 5|
          (value.to_i + sum).to_s
        end
      end

      it 'uses the block to transform the value' do
        expect(caster.cast('10')).to eq('15')
      end
    end

    context 'when options are given and the block accepts options' do
      subject(:caster) do
        caster_class.new do |value, sum:|
          (value.to_i + sum).to_s
        end
      end

      it 'uses the options in the block' do
        expect(caster.cast('10', sum: 5)).to eq('15')
      end
    end

    context 'when no options are given and the block requires options' do
      subject(:caster) do
        caster_class.new do |value, sum:|
          (value.to_i + sum).to_s
        end
      end

      it do
        expect { caster.cast('10') }.to raise_error(ArgumentError)
      end
    end

    context 'when extra options are given and the block accepts options' do
      subject(:caster) do
        caster_class.new do |value, sum:|
          (value.to_i + sum).to_s
        end
      end

      it 'ignores extra options' do
        expect(caster.cast('10', sum: 5, extra: true)).to eq('15')
      end
    end
  end
end

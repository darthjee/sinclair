# frozen_string_literal: true

require 'spec_helper'

describe Sinclair do
  describe 'README' do
    describe 'Define method using block' do
      it 'adds the method' do
        klass = Class.new
        instance = klass.new

        builder = described_class.new(klass)
        builder.add_method(:random_number) { Random.rand(10..20) }
        builder.build

        expect(instance.random_number).to be_between(10, 20)
      end
    end

    describe 'Define method using string' do
      it 'adds the method' do
        klass = Class.new
        instance = klass.new

        builder = described_class.new(klass)
        builder.add_method(:random_number, 'Random.rand(10..20)')
        builder.build

        expect(instance.random_number).to be_between(10, 20)
      end
    end

    describe 'Define method using string with parameters' do
      it 'adds the method' do
        klass = Class.new

        Sinclair.build(klass) do
          add_class_method(
            :function, 'a ** b + c', parameters: [:a], named_parameters: [:b, { c: 15 }]
          )
        end

        expect(klass.function(10, b: 2)).to eq(115)
      end
    end

    describe 'Define method using call to the class' do
      it 'performs the call to the class' do
        klass = Class.new

        builder = described_class.new(klass)
        builder.add_class_method(:attr_accessor, :number, type: :call)
        builder.build

        expect(klass.number).to be_nil
        klass.number = 10
        expect(klass.number).to eq(10)
      end
    end
  end
end

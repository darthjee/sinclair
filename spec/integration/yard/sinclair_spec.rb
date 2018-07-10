# frozen_string_literal: true

require 'spec_helper'

describe 'yarn' do
  describe Sinclair do
    let(:klass)    { Class.new(MyModel) }
    let(:instance) { klass.new }
    let(:builder)  { Sinclair.new(klass) }
    let(:default_value) { 10 }

    describe '#initialize' do
      describe '#total_price' do
        before do
          subject.eval_and_add_method(:total_price) do
            code = 'self.value * self.quantity'
            code.concat ' rescue 0' if options_object.rescue_error
            code
          end

          subject.build
        end

        context 'without options' do
          subject { Sinclair.new(klass, rescue_error: true) }

          let(:klass) { Class.new(Purchase) }
          let(:instance) { klass.new(2.3, 5) }

          it 'evaluates into default_value' do
            expect(instance.total_price).to eq(0)
          end
        end

        context 'with options' do
          subject { Sinclair.new(klass) }

          let(:klass) { Class.new(Purchase) }
          let(:instance) { klass.new(2.3, 5) }

          it do
            expect { instance.total_price }.to raise_error(NoMethodError)
          end

          context 'with attribute readers' do
            before do
              klass.send(:attr_reader, :value, :quantity)
            end

            it 'calculates total price' do
              expect(instance.total_price).to eq(11.5)
            end
          end
        end
      end
    end

    describe '#build' do
      before do
        value = default_value
        builder.add_method(:default_value) { value }
        builder.add_method(:value, '@value || default_value')
        builder.add_method(:value=) { |val| @value = val }
      end

      context 'after the build' do
        before { builder.build }
        it 'creates the expected methods' do
          expect(instance.value).to eq(10)
        end

        context 'when default value is overwritten' do
          before do
            instance.value = 20
          end

          it 'returns the new written value' do
            expect(instance.value).to eq(20)
          end
        end
      end

      context 'calling the build' do
        it do
          expect do
            builder.build
          end.to change { instance.respond_to?(:default_value) }.to(true)
        end
      end
    end

    describe '#add_method' do
      let(:klass) { Class.new(Person) }
      let(:instance) { klass.new('john', 'wick') }

      before do
        builder.add_method(:full_name, '[first_name, last_name].join(" ")')
        builder.add_method(:bond_name) { "#{last_name}, #{first_name} #{last_name}" }
        builder.build
      end

      describe '#full_name' do
        let(:klass) { Class.new(Person) }
        let(:instance) { klass.new('john', 'wick') }

        before do
          builder.add_method(:full_name, '[first_name, last_name].join(" ")')
          builder.build
        end

        it 'returns the full name' do
          expect(instance.bond_name).to eq('wick, john wick')
        end
      end

      describe '#bond_style' do
      end
    end

    describe '#eval_and_add_method' do
      subject { klass.new }

      let(:klass) do
        Class.new do
          include InitialValuer
          attr_writer :age
          initial_value_for :age, 20
        end
      end

      describe '#age' do
        context 'when it has not been initialized' do
          it do
            expect(subject.age).to eq(20)
          end
        end

        context 'when it has been initialized' do
          before do
            subject.age
            subject.age = 30
          end

          it do
            expect(subject.age).to eq(30)
          end
        end
      end
    end
  end
end

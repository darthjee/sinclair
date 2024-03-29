# frozen_string_literal: false

require 'spec_helper'

describe Sinclair do
  describe 'yard' do
    let(:klass)   { Class.new(MyModel) }
    let(:builder) { described_class.new(klass) }

    describe 'Using cache' do
      subject(:server) { Server.new }

      it 'returns default url' do
        expect(server.url).to eq('http://server.com:80')
      end

      context 'when new values are set' do
        before do
          server.host = 'interstella.com'
          server.port = 5555
        end

        it 'returns custom url' do
          expect(server.url).to eq('http://interstella.com:5555')
        end

        context 'when values are nullified' do
          before do
            server.host = nil
            server.port = nil
          end

          it 'returns url with default + custom nil values' do
            expect(server.url).to eq('http://server.com')
          end
        end
      end
    end

    describe '#initialize' do
      describe '#total_price' do
        before do
          builder.eval_and_add_method(:total_price) do
            code = 'self.value * self.quantity'
            code.concat ' rescue 0' if options_object.rescue_error
            code
          end

          builder.build
        end

        context 'without options' do
          subject(:builder) { described_class.new(klass, rescue_error: true) }

          let(:klass) { Class.new(Purchase) }
          let(:instance) { klass.new(2.3, 5) }

          it 'evaluates into default_value' do
            expect(instance.total_price).to eq(0)
          end
        end

        context 'with options' do
          subject(:model) { described_class.new(klass) }

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

    describe 'Stand alone usage' do
      it 'builds the methods' do
        value = 10

        Sinclair.build(klass) do
          add_method(:default_value) { value }
          add_method(:value, '@value || default_value')
          add_method(:value=) { |val| @value = val }
        end

        instance = klass.new

        expect(instance.value).to eq(10)
        instance.value = 20
        expect(instance.value).to eq(20)
      end
    end
  end
end

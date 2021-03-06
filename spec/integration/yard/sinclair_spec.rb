# frozen_string_literal: false

require 'spec_helper'

describe Sinclair do
  describe 'yarn' do
    let(:klass)         { Class.new(MyModel) }
    let(:instance)      { klass.new }
    let(:builder)       { described_class.new(klass) }
    let(:default_value) { 10 }

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

    describe '#build' do
      before do
        value = default_value
        builder.add_method(:default_value) { value }
        builder.add_method(:value, '@value || default_value')
        builder.add_method(:value=) { |val| @value = val }
      end

      describe 'after the build' do
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

      context 'when calling the build' do
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
        it 'returns the full name' do
          expect(instance.full_name).to eq('john wick')
        end
      end

      describe '#bond_name' do
        it 'returns the full name, bond style' do
          expect(instance.bond_name).to eq('wick, john wick')
        end
      end
    end

    describe '#add_class_method' do
      let(:klass)       { env_fetcher }
      let(:env_fetcher) { Class.new }

      describe '#hostname' do
        before do
          builder.add_class_method(:hostname, 'ENV["HOSTNAME"]')
          builder.build
          ENV['HOSTNAME'] = 'myhost'
        end

        it 'returns the hostname' do
          expect(env_fetcher.hostname).to eq('myhost')
        end
      end

      describe '#timeout' do
        before do
          builder.add_class_method(:timeout) { ENV['TIMEOUT'] }
          builder.build
          ENV['TIMEOUT'] = '300'
        end

        it 'returns the timeout' do
          expect(env_fetcher.timeout).to eq('300')
        end
      end
    end

    describe '#eval_and_add_method' do
      subject(:builder) { klass.new }

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
            expect(builder.age).to eq(20)
          end
        end

        context 'when it has been initialized' do
          before do
            builder.age
            builder.age = 30
          end

          it do
            expect(builder.age).to eq(30)
          end
        end
      end
    end
  end
end

# frozen_string_literal: false

require 'spec_helper'

describe Sinclair do
  describe 'yarn' do
    let(:klass)         { Class.new(MyModel) }
    let(:instance)      { klass.new }
    let(:builder)       { described_class.new(klass) }
    let(:default_value) { 10 }

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

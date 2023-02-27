# frozen_string_literal: false

require 'spec_helper'

describe Sinclair do
  describe 'yarn' do
    describe '#add_class_method' do
      let(:klass) { Class.new }

      describe 'Adding a method by String' do
        it 'returns the hostname' do
          builder = Sinclair.new(klass)
          builder.add_class_method(:hostname, 'ENV["HOSTNAME"]')
          builder.build
          ENV['HOSTNAME'] = 'myhost'

          expect(klass.hostname).to eq('myhost')
        end
      end

      describe 'Adding a method by Block' do
        it 'returns the timeout' do
          builder = Sinclair.new(klass)
          builder.add_class_method(:timeout) { ENV['TIMEOUT'] }
          builder.build
          ENV['TIMEOUT'] = '300'

          expect(klass.timeout).to eq('300')
        end
      end
    end

    describe '#eval_and_add_method' do
      describe 'Building a initial value class method' do
        let(:klass) do
          Class.new do
            include InitialValuer
            attr_writer :age
            initial_value_for :age, 20
          end
        end

        context 'when it has not been initialized' do
          it do
            object = klass.new

            expect(object.age).to eq(20)
            object.age = 30
            expect(object.age).to eq(30)
          end
        end
      end
    end
  end
end

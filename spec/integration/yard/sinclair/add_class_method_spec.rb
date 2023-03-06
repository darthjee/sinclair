# frozen_string_literal: false

require 'spec_helper'

describe 'yard Sinclair#add_class_method' do
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

  describe 'Passing type block' do
    it 'creates new method' do
      builder = Sinclair.new(klass)
      builder.add_class_method(:timeout, type: :block) { ENV['TIMEOUT'] }
      builder.build
      ENV['TIMEOUT'] = '300'

      expect(klass.timeout).to eq('300')
    end
  end

  describe 'Passing type call' do
    it 'creates new method' do
      builder = Sinclair.new(klass)
      builder.add_class_method(:attr_accessor, :timeout, type: :call)
      builder.build

      klass.timeout = 10
      expect(klass.timeout).to eq(10)
    end
  end
end

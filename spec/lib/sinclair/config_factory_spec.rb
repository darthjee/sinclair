require 'spec_helper'

describe Sinclair::ConfigFactory do
  subject(:factory) { described_class.new }

  describe '#config' do
    it { expect(factory.config).to be_a(Sinclair::Config) }
  end
end

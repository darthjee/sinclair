require 'spec_helper'

describe Sinclair::ConfigFactory do
  subject(:factory) { described_class.new }

  describe '#build' do
    it { expect(factory.build).to be_a(Sinclair::Config) }
  end
end

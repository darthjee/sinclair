require 'spec_helper'

describe Sinclair::Configurable do
  subject(:configurable) { DummyConfigurable }

  describe '.config' do
    it { expect(configurable.config).to be_a(Sinclair::Config) }
  end
end

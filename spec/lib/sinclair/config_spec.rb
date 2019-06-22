# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Config do
  subject(:child_klass) { Class.new(klass) }

  let(:klass) { Class.new(described_class) }

  describe '.add_attributes' do
    it_behaves_like 'a config class with .add_attributes method'
  end

  describe 'attributes' do
    it_behaves_like 'a config class with .attributes method'
  end
end

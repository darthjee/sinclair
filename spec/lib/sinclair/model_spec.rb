# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Model do
  describe '.for' do
    subject(:klass) { described_class.for(*attributes, **options) }

    it_behaves_like 'sinclair model building'
  end

  describe '.initialize_with' do
    subject(:klass) { Class.new(described_class) }

    before do
      klass.initialize_with(*attributes, **options)
    end

    it_behaves_like 'sinclair model building'
  end
end

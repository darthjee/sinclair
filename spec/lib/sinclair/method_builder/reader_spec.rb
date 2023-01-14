# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::Reader do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, *attributes, type: type)
    end

    it_behaves_like 'a method builder that adds attribute reader'
  end
end

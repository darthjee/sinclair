# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::Base do
  describe '.build' do
    let(:klass) { Class.new }
    let(:type) { Sinclair::MethodBuilder::CLASS_METHOD }

    it do
      expect { described_class.build(klass, instance_of(described_class), type: type) }
        .to raise_error(NotImplementedError)
    end
  end
end

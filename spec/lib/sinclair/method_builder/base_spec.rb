# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::MethodBuilder::Base do
  describe '.build' do
    let(:klass) { Class.new }
    let(:type) { Sinclair::MethodBuilder::CLASS_METHOD }

    context 'when the builder has not been defined' do
      it do
        expect { described_class.build(klass, instance_of(described_class), type: type) }
      end
    end

    context 'when the builder has been defined' do
    end
  end
end

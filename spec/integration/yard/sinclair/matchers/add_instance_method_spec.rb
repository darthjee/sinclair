# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sinclair::Matchers::AddInstanceMethod do
  describe 'yard' do
    describe '#to' do
      context 'when checking against Class' do
        let(:clazz)   { Class.new }
        let(:builder) { Sinclair.new(clazz) }

        before do
          builder.add_method(:new_method, '2')
        end

        it do
          expect { builder.build }.to add_method(:new_method).to(clazz)
        end
      end

      context 'when checking against instance' do
        let(:clazz)    { Class.new }
        let(:builder)  { Sinclair.new(clazz) }
        let(:instance) { clazz.new }

        before do
          builder.add_method(:the_method, 'true')
        end

        it do
          expect { builder.build }.to add_method(:the_method).to(instance)
        end
      end
    end
  end
end

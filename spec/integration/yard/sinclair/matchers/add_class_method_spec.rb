# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sinclair::Matchers::AddClassMethod do
  describe 'yard' do
    describe '#to' do
      context 'when checking against Class' do
        let(:clazz) { Class.new }

        let(:block) do
          proc do
            clazz.define_singleton_method(:new_method) { 2 }
          end
        end

        it do
          expect(&block).to add_class_method(:new_method).to(clazz)
        end
      end
    end
  end
end

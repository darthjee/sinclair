# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sinclair::Matchers::ChangeInstanceMethod do
  describe 'yard' do
    describe '#on' do
      context 'when checking against Class' do
        let(:klass)   { Class.new(MyModel) }
        let(:builder) { Sinclair.new(klass) }

        before do
          builder.add_method(:the_method) { 10 }
          builder.build
          builder.add_method(:the_method) { 20 }
        end

        it do
          expect { builder.build }.to change_method(:the_method).on(klass)
        end
      end
    end
  end
end


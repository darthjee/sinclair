# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::AddMethodTo do
  describe 'yard' do
    let(:klass)   { Class.new(MyModel) }
    let(:builder) { Sinclair.new(klass) }

    before do
      builder.add_method(:class_name, 'self.class.name')
    end

    it do
      expect { builder.build }.to add_method(:class_name).to(klass)
    end
  end
end

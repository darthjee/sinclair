# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::AddClassMethodTo do
  describe 'yard' do
    let(:klass)   { Class.new(MyModel) }

    let(:block) do
      proc do
        klass.define_singleton_method(:parent_name) { superclass.name }
      end
    end

    it do
      expect(&block).to add_class_method(:parent_name).to(klass)
    end
  end
end

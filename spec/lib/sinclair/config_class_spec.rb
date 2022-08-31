# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigClass do
  subject(:klass) do
    Class.new { extend Sinclair::ConfigClass }
  end

  let(:child_klass) { Class.new(klass) }

  let(:config)      { klass.new }

  describe '.config_attributes' do
    it_behaves_like 'a config class with .config_attributes method'
  end

  describe '.add_configs' do
    it_behaves_like 'a config class with .add_configs method'
  end
end

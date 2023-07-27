# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Settable::ClassMethods do
  describe 'yard #read_with' do
    it 'reads the settings from the file' do
      expect(YamlFileSettings.timeout).to eq(10)
    end
  end
end

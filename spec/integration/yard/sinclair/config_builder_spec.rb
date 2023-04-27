# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigBuilder do
  describe 'yard' do
    describe '#instance_eval' do
      it 'sets variable from config' do
        config =  MyConfig.new

        builder = described_class.new(config, :name)

        builder.instance_eval { |c| c.name 'John' }

        expect(config.name).to eq('John')
      end
    end
  end
end

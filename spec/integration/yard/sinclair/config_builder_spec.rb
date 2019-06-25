# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::ConfigBuilder do
  describe 'yard' do
    describe '#instance_eval' do
      subject(:builder) do
        described_class.new(config, :name)
      end

      let(:config) { MyConfig.new }

      it 'sets variable from config' do
        expect { builder.instance_eval { |c| c.name 'John' } }
          .to change(config, :name)
          .from(nil).to('John')
      end
    end
  end
end

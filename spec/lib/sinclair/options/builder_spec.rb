# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options::Builder do
  describe '#build' do
    subject(:builder) do
      described_class.new(klass, *args)
    end

    let(:klass)   { Class.new(Sinclair::Options) }
    let(:options) { klass.new }

    let(:test_keys) do
      %i[timeout retries invalid]
    end

    context 'when calling with keys' do
      let(:args) { [:timeout, 'retries'] }

      it 'add first method' do
        expect { builder.build }
          .to add_method(:timeout).to(klass)
      end

      it 'add second method' do
        expect { builder.build }
          .to add_method(:retries).to(klass)
      end

      it do
        expect { builder.build }
          .to change { klass.invalid_options_in(test_keys) }
          .from(test_keys)
          .to([:invalid])
      end

      it do
        expect { builder.build }
          .not_to change { Sinclair::Options.invalid_options_in(test_keys) }
      end

      context 'when when calling method after building' do
        before { builder.build }

        it { expect(options.timeout).to be_nil }
      end
    end

    context 'when calling with a hash' do
      let(:args) { [{ timeout_sec: 10, 'retries' => 20 }] }

      it 'adds method' do
        expect { builder.build }
          .to add_method(:timeout_sec).to(klass)
      end

      context 'when when calling method after building' do
        before { builder.build }

        it 'returns default value' do
          expect(options.retries).to eq(20)
        end
      end
    end

    context 'when calling on subclass' do
      let(:super_class) { Class.new(Sinclair::Options) }
      let(:klass)       { Class.new(super_class) }
      let(:args) do
        [:protocol, { 'port' => 443 }]
      end

      let(:test_keys) do
        %i[timeout retries protocol port invalid]
      end

      let(:super_builder) do
        described_class.new(super_class, :timeout, 'retries')
      end

      before { super_builder.build }

      it 'add first method' do
        expect { builder.build }
          .to add_method(:protocol).to(klass)
      end

      it 'add second method' do
        expect { builder.build }
          .to add_method(:port).to(klass)
      end

      it do
        expect { builder.build }
          .to change { klass.invalid_options_in(test_keys) }
          .from(%i[protocol port invalid])
          .to(%i[invalid])
      end

      it do
        expect { builder.build }
          .not_to change { super_class.invalid_options_in(test_keys) }
      end
    end
  end
end

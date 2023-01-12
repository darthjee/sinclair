# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Options::ClassMethods do
  subject(:options) { klass.new }

  describe '.with_options' do
    let(:klass)     { Class.new(Sinclair::Options) }
    let(:test_keys) { %i[timeout retries invalid] }

    context 'when calling with keys' do
      it 'add first method' do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .to add_method(:timeout).to(klass)
      end

      it 'add second method' do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .to add_method(:retries).to(klass)
      end

      it 'adds options to allowed' do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .to change { klass.invalid_options_in(test_keys) }
          .from(%i[timeout retries invalid])
          .to([:invalid])
      end

      context 'when the added fild makes an object different' do
        let(:options1_hash) { { timeout: 10 } }
        let(:options2_hash) { { timeout: 11 } }

        before do
          klass.skip_validation
        end

        it 'adds the field to == check' do
          expect { klass.send(:with_options, :timeout) }
            .to change { klass.new(options1_hash) == klass.new(options2_hash) }
            .from(true).to(false)
        end
      end

      it do
        expect { klass.send(:with_options, :timeout, 'retries') }
          .not_to change {
            Sinclair::Options.invalid_options_in(%i[timeout retries invalid])
          }
      end

      context 'when when calling method after building' do
        before { klass.send(:with_options, :timeout, 'retries') }

        it { expect(options.timeout).to be_nil }
      end

      context 'when calling method twice' do
        before { klass.send(:with_options, :timeout, retries: 10) }

        it do
          expect { klass.send(:with_options, :timeout, :retries) }
            .not_to change {
              klass.invalid_options_in(%i[timeout retries invalid])
            }
        end
      end
    end

    context 'when calling with a hash' do
      it 'adds method' do
        expect { klass.send(:with_options, timeout_sec: 10, 'retries' => 20) }
          .to add_method(:timeout_sec).to(klass)
      end

      context 'when when calling method after building' do
        before { klass.send(:with_options, timeout_sec: 10, 'retries' => 20) }

        it 'returns default value' do
          expect(options.retries).to eq(20)
        end
      end
    end

    context 'when calling on subclass' do
      let(:super_class) { Class.new(Sinclair::Options) }
      let(:klass)       { Class.new(super_class) }

      let(:test_keys) do
        %i[timeout retries name protocol port invalid]
      end

      before { super_class.send(:with_options, :timeout, 'retries', name: 'My Connector') }

      it 'add first method' do
        expect { klass.send(:with_options, :protocol, 'port' => 443) }
          .to add_method(:protocol).to(klass)
      end

      it 'add second method' do
        expect { klass.send(:with_options, :protocol, 'port' => 443) }
          .to add_method(:port).to(klass)
      end

      it do
        expect { klass.send(:with_options, 'protocol', port: 443) }
          .to change {
            klass.invalid_options_in(test_keys)
          }.from(%i[protocol port invalid])
          .to([:invalid])
      end

      it do
        expect { klass.send(:with_options, 'protocol', port: 443) }
          .not_to change {
            super_class.invalid_options_in(%i[protocol port])
          }
      end

      context 'when overriding a method' do
        it do
          expect { klass.send(:with_options, :name, timeout: 10) }
            .not_to change { klass.invalid_options_in(%i[name timeout]) }
        end

        it 'change methods to return new default' do
          expect { klass.send(:with_options, :name, timeout: 10) }
            .to change { klass.new.timeout }
            .from(nil).to(10)
        end

        it 'change methods to return without default' do
          expect { klass.send(:with_options, :name, timeout: 10) }
            .to change { klass.new.name }
            .from('My Connector').to(nil)
        end
      end
    end
  end

  describe '.invalid_options_in' do
    let(:klass)     { Class.new(Sinclair::Options) }
    let(:test_keys) { %i[timeout invalid] }

    it 'returns alls keys as invalid' do
      expect(klass.invalid_options_in(test_keys))
        .to eq(test_keys)
    end

    context 'when allowed options was never set' do
      before { klass.allow(:timeout) }

      it 'returns keys that are not allowed by the input' do
        expect(klass.invalid_options_in(test_keys))
          .to eq([:invalid])
      end
    end

    context 'when calling on subclass' do
      let(:super_class) { Class.new(Sinclair::Options) }
      let(:klass)       { Class.new(super_class) }
      let(:test_keys)   { %i[timeout invalid] }

      before { super_class.allow(:timeout) }

      context 'when not adding allowed options' do
        it 'returns keys that are not allowed by the input' do
          expect(klass.invalid_options_in(test_keys))
            .to eq([:invalid])
        end
      end

      context 'when adding keys' do
        before { super_class.allow(:retries) }

        it 'returns keys that are not allowed by the input' do
          expect(klass.invalid_options_in(test_keys))
            .to eq([:invalid])
        end

        it 'adds new key to accepted' do
          expect(klass.invalid_options_in([:retries]))
            .to be_empty
        end
      end
    end
  end

  describe '.allow' do
    let(:klass)     { Class.new(Sinclair::Options) }
    let(:test_keys) { %i[timeout retries invalid] }

    it 'adds options to allowed' do
      expect { klass.allow(:timeout) }
        .to change { klass.invalid_options_in(test_keys) }
        .from(%i[timeout retries invalid])
        .to(%i[retries invalid])
    end

    context 'when calling on subclass' do
      let(:super_class) { Class.new(Sinclair::Options) }
      let(:klass)       { Class.new(super_class) }

      before { super_class.allow(:timeout) }

      it 'adds options to allowed' do
        expect { klass.allow(:retries) }
          .to change { klass.invalid_options_in(test_keys) }
          .from(%i[retries invalid])
          .to(%i[invalid])
      end
    end
  end

  describe '.allowed_options' do
    let(:klass) { Class.new(Sinclair::Options) }

    context 'when class has not been changed' do
      it { expect(klass.allowed_options).to be_a(Set) }
    end

    context 'when initializing with with options' do
      let(:expected) do
        Set.new %i[timeout retries port protocol]
      end

      before do
        klass.send(
          :with_options,
          :timeout, :retries, port: 443, protocol: 'https'
        )
      end

      it do
        expect(klass.allowed_options)
          .to eq(expected)
      end

      context 'when class is descendent' do
        let(:descendent_class) { Class.new(klass) }
        let(:expected) do
          Set.new %i[timeout retries port protocol name]
        end

        before do
          descendent_class.send(
            :with_options,
            :name
          )
        end

        it do
          expect(descendent_class.allowed_options)
            .to eq(expected)
        end
      end
    end
  end

  describe '.skip_validation' do
    let(:klass) { Class.new(Sinclair::Options) }

    it 'skip initialization validation' do
      klass.send(:skip_validation)

      expect { klass.new(invalid: 10) }
        .not_to raise_error
    end
  end
end

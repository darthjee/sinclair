# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::ChangeInstanceMethodOn do
  subject(:matcher) { described_class.new(instance, method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#matches?' do
    let(:event_proc) do
      proc { klass.send(:define_method, method) {} }
    end

    context 'when class has the method' do
      before { klass.send(:define_method, method) {} }

      context 'when a method is changed' do
        it { expect(matcher).to be_matches(event_proc) }
      end

      context 'when a method is not changed' do
        let(:event_proc) { proc {} }

        it { expect(matcher).not_to be_matches(event_proc) }
      end

      context 'when the wrong method is changed' do
        let(:event_proc) do
          proc { klass.send(:define_method, :another_method) {} }
        end

        it { expect(matcher).not_to be_matches(event_proc) }
      end
    end

    context 'when class does not have the method' do
      context 'when a method is added' do
        it { expect(matcher).not_to be_matches(event_proc) }
      end
    end

    context 'when initializing with class' do
      subject(:matcher) { described_class.new(klass, method) }

      before { klass.send(:define_method, method) {} }

      context 'when a method is added' do
        it { expect(matcher).to be_matches(event_proc) }
      end
    end

    context 'when a block is given' do
      it do
        expect { matcher.matches?(event_proc) { 1 } }
          .to raise_error(
            SyntaxError, 'Block not received by the `change_instance_method_on` matcher. ' \
            'Perhaps you want to use `{ ... }` instead of do/end?'
          )
      end
    end
  end

  describe '#failure_message_for_should' do
    context 'when method already exited' do
      before do
        klass.send(:define_method, method) {}
        matcher.matches?(proc {})
      end

      it 'returns information on the instance class and method' do
        expect(matcher.failure_message_for_should)
          .to eq("expected '#{method}' to be changed on #{klass} but it didn't")
      end
    end

    context 'when method did not exite' do
      it 'returns information on the instance class and method' do
        expect(matcher.failure_message_for_should)
          .to eq("expected '#{method}' to be changed on #{klass} but it didn't exist")
      end
    end

    context 'when initializing with class and method already existed' do
      subject(:matcher) { described_class.new(klass, method) }

      before do
        klass.send(:define_method, method) {}
        matcher.matches?(proc {})
      end

      it 'returns information on the instance class and method' do
        expect(matcher.failure_message_for_should)
          .to eq("expected '#{method}' to be changed on #{klass} but it didn't")
      end
    end

    context 'when initializing with class and method didnt exist' do
      subject(:matcher) { described_class.new(klass, method) }

      it 'returns information on the instance class and method' do
        expect(matcher.failure_message_for_should)
          .to eq("expected '#{method}' to be changed on #{klass} but it didn't exist")
      end
    end
  end

  describe '#failure_message_for_should_not' do
    it 'returns information on the instance class and method' do
      expect(matcher.failure_message_for_should_not)
        .to eq("expected '#{method}' not to be changed on #{klass} but it was")
    end

    context 'when initializing with class' do
      subject(:matcher) { described_class.new(klass, method) }

      it 'returns information on the instance class and method' do
        expect(matcher.failure_message_for_should_not)
          .to eq("expected '#{method}' not to be changed on #{klass} but it was")
      end
    end
  end

  describe 'description' do
    it 'returns information on the instance class and method' do
      expect(matcher.description)
        .to eq("change method '#{method}' on #{klass} instances")
    end

    context 'when initializing with class' do
      subject(:matcher) { described_class.new(klass, method) }

      it 'returns information on the instance class and method' do
        expect(matcher.description)
          .to eq("change method '#{method}' on #{klass} instances")
      end
    end
  end
end

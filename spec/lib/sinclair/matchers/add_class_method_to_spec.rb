# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers::AddClassMethodTo do
  subject(:matcher) { described_class.new(klass, method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }

  describe '#matches?' do
    let(:event_proc) do
      proc { klass.send(:define_singleton_method, method) {} }
    end

    context 'when class does not have the method yet' do
      context 'when a method is added' do
        it { expect(matcher).to be_matches(event_proc) }
      end

      context 'when a method is not added' do
        let(:event_proc) { proc {} }

        it { expect(matcher).not_to be_matches(event_proc) }
      end

      context 'when the wrong method is added' do
        let(:event_proc) do
          proc { klass.send(:define_singleton_method, :another_method) {} }
        end

        it { expect(matcher).not_to be_matches(event_proc) }
      end
    end

    context 'when class already has the method' do
      before { klass.send(:define_singleton_method, method) {} }

      context 'when a method is changed' do
        it { expect(matcher).not_to be_matches(event_proc) }
      end
    end

    context 'when a block is given' do
      it do
        expect { matcher.matches?(event_proc) { 1 } }
          .to raise_error(
            SyntaxError, 'Block not received by the `add_class_method_to` matcher. ' \
            'Perhaps you want to use `{ ... }` instead of do/end?'
          )
      end
    end
  end

  describe '#failure_message_for_should' do
    it 'returns information on the instance class and method' do
      expect(matcher.failure_message_for_should)
        .to eq("expected class_method '#{method}' to be added to #{klass} but it didn't")
    end

    context 'when method already exited' do
      before do
        klass.send(:define_singleton_method, method) {}
        matcher.matches?(proc {})
      end

      it 'returns information on the instance class and method' do
        expect(matcher.failure_message_for_should)
          .to eq("expected class_method '#{method}' to be added to #{klass} but it already existed")
      end
    end
  end

  describe '#failure_message_for_should_not' do
    it 'returns information on the instance class and method' do
      expect(matcher.failure_message_for_should_not)
        .to eq("expected class_method '#{method}' not to be added to #{klass} but it was")
    end
  end

  describe 'description' do
    it 'returns information on the instance class and method' do
      expect(matcher.description)
        .to eq("add method class_method '#{method}' to #{klass}")
    end
  end
end

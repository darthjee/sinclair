require 'spec_helper'

describe Sinclair::Matchers::AddMethodTo do
  subject { described_class.new(instance, method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#matches?' do
    let(:event_proc) do
      proc { klass.send(:define_method, method) {} }
    end

    context 'when a method is added' do
      it { expect(subject.matches?(event_proc)).to be_truthy }
    end

    context 'when a method is not added' do
      let(:event_proc) { proc {} }

      it { expect(subject.matches?(event_proc)).to be_falsey }
    end

    context 'when the wrong method is added' do
      let(:event_proc) do
        proc { klass.send(:define_method, :another_method) {} }
      end

      it { expect(subject.matches?(event_proc)).to be_falsey }
    end

    context 'when initializing with class' do
      subject { described_class.new(klass, method) }

      context 'when a method is added' do
        it { expect(subject.matches?(event_proc)).to be_truthy }
      end
    end
  end

  describe '#failure_message_for_should' do
    it 'returns information on the instance class and method' do
      expect(subject.failure_message_for_should)
        .to eq("expected '#{method}' to be added to #{klass} but it didn't")
    end

    context 'when method already exited' do
      before do
        klass.send(:define_method, method) {}
        subject.matches?(proc {})
      end

      it 'returns information on the instance class and method' do
        expect(subject.failure_message_for_should)
          .to eq("expected '#{method}' to be added to #{klass} but it already existed")
      end
    end

    context 'when initializing with class' do
      subject { described_class.new(klass, method) }

      it 'returns information on the instance class and method' do
        expect(subject.failure_message_for_should)
          .to eq("expected '#{method}' to be added to #{klass} but it didn't")
      end

      context 'when method already exited' do
        before do
          klass.send(:define_method, method) {}
          subject.matches?(proc {})
        end

        it 'returns information on the instance class and method' do
          expect(subject.failure_message_for_should)
            .to eq("expected '#{method}' to be added to #{klass} but it already existed")
        end
      end
    end
  end

  describe '#failure_message_for_should_not' do
    it 'returns information on the instance class and method' do
      expect(subject.failure_message_for_should_not)
        .to eq("expected '#{method}' not to be added to #{klass} but it was")
    end

    context 'when initializing with class' do
      subject { described_class.new(klass, method) }

      it 'returns information on the instance class and method' do
        expect(subject.failure_message_for_should_not)
          .to eq("expected '#{method}' not to be added to #{klass} but it was")
      end
    end
  end

  describe 'description' do
    it 'returns information on the instance class and method' do
      expect(subject.description)
        .to eq("add method '#{method}' to #{klass} instances")
    end

    context 'when initializing with class' do
      subject { described_class.new(klass, method) }

      it 'returns information on the instance class and method' do
        expect(subject.description)
          .to eq("add method '#{method}' to #{klass} instances")
      end
    end
  end
end

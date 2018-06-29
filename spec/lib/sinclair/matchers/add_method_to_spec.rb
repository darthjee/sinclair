require 'spec_helper'

describe Sinclair::Matchers::AddMethodTo do
  subject { described_class.new(instance, method) }

  let(:method)   { :the_method }
  let(:klass)    { Class.new }
  let(:instance) { klass.new }

  describe '#matches?' do
    context 'when a method is added' do
      let(:event_proc) do
        Proc.new { klass.send(:define_method, method) {} }
      end

      it { expect(subject.matches? event_proc).to be_truthy }
    end

    context 'when a method is not added' do
      let(:event_proc) do
        Proc.new {}
      end

      it { expect(subject.matches? event_proc).to be_falsey }
    end

    context 'when the wrong method is added' do
      let(:event_proc) do
        Proc.new { klass.send(:define_method, :another_method) {} }
      end

      it { expect(subject.matches? event_proc).to be_falsey }
    end
  end

  describe '#failure_message_for_should' do
    it 'returns information on the instance class and method' do
      expect(subject.failure_message_for_should)
        .to eq("expected '#{method}' to be added to #{klass} but it didn't")
    end
  end

  describe 'description' do
    it 'returns information on the instance class and method' do
      expect(subject.description)
        .to eq("add method '#{method}' to #{klass} instances")
    end
  end
end

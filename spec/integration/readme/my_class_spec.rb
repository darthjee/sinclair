require 'spec_helper'

describe MyClass do
  subject { clazz.new(attributes) }
  let(:clazz) { MyClass }
  let(:name) { 'name' }
  let(:age) { 20 }
  let(:attributes) do
    {
      name: name,
      surname: 'surname',
      age: age,
      legs: 2
    }
  end

  %i(name surname age legs).each do |field|
    it do
      expect(subject).to respond_to(field)
    end

    it do
      expect(subject).to respond_to("#{field}_valid?")
    end
  end

  it do
    expect(subject).to respond_to(:valid?)
  end

  describe '#valid?' do
    it do
      expect(subject).to be_valid
    end

    context 'when a string attribute is a symbol' do
      let(:name) { :name }
      it do
        expect(subject).not_to be_valid
      end
    end

    context 'when an attribute is nil' do
      let(:age) { nil }
      it do
        expect(subject).not_to be_valid
      end
    end
  end
end

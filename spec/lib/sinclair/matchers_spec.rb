# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Matchers do
  describe '#add_method' do
    it 'has been added to DSL' do
      expect(respond_to?(:add_method)).to be_truthy
    end

    it do
      expect(add_method(:method_name)).to be_a(described_class::AddInstanceMethod)
    end

    it 'returns the matcher with correct argument' do
      expect(add_method(:method_name)).to eq(described_class::AddInstanceMethod.new(:method_name))
    end
  end

  describe '#add_class_method' do
    it 'has been added to DSL' do
      expect(respond_to?(:add_class_method)).to be_truthy
    end

    it do
      expect(add_class_method(:method_name)).to be_a(described_class::AddClassMethod)
    end

    it 'returns the matcher with correct argument' do
      expect(add_class_method(:method_name))
        .to eq(described_class::AddClassMethod.new(:method_name))
    end
  end

  describe '#change_method' do
    it 'has been added to DSL' do
      expect(respond_to?(:change_method)).to be_truthy
    end

    it do
      expect(change_method(:method_name)).to be_a(described_class::ChangeInstanceMethod)
    end

    it 'returns the matcher with correct argument' do
      expect(change_method(:method_name))
        .to eq(described_class::ChangeInstanceMethod.new(:method_name))
    end
  end

  describe '#change_class_method' do
    it 'has been added to DSL' do
      expect(respond_to?(:change_class_method)).to be_truthy
    end

    it do
      expect(change_class_method(:method_name)).to be_a(described_class::ChangeClassMethod)
    end

    it 'returns the matcher with correct argument' do
      expect(change_class_method(:method_name))
        .to eq(described_class::ChangeClassMethod.new(:method_name))
    end
  end
end

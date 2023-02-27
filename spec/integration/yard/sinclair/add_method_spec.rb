# frozen_string_literal: false

require 'spec_helper'

describe Sinclair do
  describe 'yarn' do
    describe '#add_method' do
      describe 'Using string code to add a string defined method' do
        let(:klass) { Class.new(Person) }

        it 'creates new method' do
          builder = Sinclair.new(klass)
          builder.add_method(:full_name, '[first_name, last_name].join(" ")')
          builder.build

          expect(klass.new('john', 'wick').full_name).to eq('john wick')
        end
      end

      describe 'Using block to add a block method' do
        let(:klass) { Class.new(Person) }

        it 'creates new method' do
          builder = Sinclair.new(klass)
          builder.add_method(:bond_name) { "#{last_name}, #{first_name} #{last_name}" }
          builder.build

          expect(klass.new('john', 'wick').bond_name).to eq('wick, john wick')
        end
      end

      describe 'Passing type block' do
        let(:klass) { Class.new(Person) }

        it 'creates new method' do
          builder = Sinclair.new(klass)
          builder.add_method(:bond_name, type: :block, cached: true) do
            "#{last_name}, #{first_name} #{last_name}"
          end
          builder.build
          person = klass.new('john', 'wick')

          expect(person.bond_name).to eq('wick, john wick')
          person.first_name = 'Johny'
          expect(person.bond_name).to eq('wick, john wick')
        end
      end

      describe 'Passing type call' do
        let(:klass) { Class.new }

        it 'creates new method' do
          builder = Sinclair.new(klass)
          builder.add_method(:attr_accessor, :bond_name, type: :call)
          builder.build
          person = klass.new

          person.bond_name = 'Bond, James Bond'
          expect(person.bond_name).to eq('Bond, James Bond')
        end
      end
    end
  end
end

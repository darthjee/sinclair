# frozen_string_literal: true

require 'spec_helper'

describe Sinclair do
  describe 'Stand Alone' do
    let(:instance) { klass.new }
    let(:klass)    { Class.new }
    let(:builder)  { described_class.new(klass) }

    before do
      builder.add_method(:twenty, '10 + 10')
      builder.add_method(:eighty) { 4 * twenty }
      builder.build
    end

    it 'knows how to add string defined methods' do
      expect("Twenty => #{instance.twenty}").to eq('Twenty => 20')
    end

    it 'knows how to add block defined methods' do
      expect("Eighty => #{instance.eighty}").to eq('Eighty => 80')
    end
  end

  describe 'Stand Alone concern' do
    subject(:person) { HttpPerson.new(json) }

    let(:json) do
      <<-JSON
        {
          "uid": "12sof511",
          "personal_information":{
            "name":"Bob",
            "age": 21
          },
          "digital_information":{
            "username":"lordbob",
            "email":"lord@bob.com"
          }
        }
      JSON
    end

    it 'adds uid method' do
      expect(person.uid).to eq('12sof511')
    end

    it 'adds name method' do
      expect(person.name).to eq('Bob')
    end

    it 'adds age method' do
      expect(person.age).to eq(21)
    end

    it 'adds username method' do
      expect(person.username).to eq('lordbob')
    end

    it 'adds email method' do
      expect(person.email).to eq('lord@bob.com')
    end
  end
end

# frozen_string_literal: true

describe Sinclair::InputHash do
  describe 'yard' do
    describe 'Regular usage' do
      it do
        expect(
          Sinclair::InputHash.input_hash(
            :key1, 'key2',
            key3: 10,
            'key4' => 20
          )
        ).to eq(
          key1: nil,
          'key2' => nil,
          key3: 10,
          'key4' => 20
        )
      end
    end
  end
end

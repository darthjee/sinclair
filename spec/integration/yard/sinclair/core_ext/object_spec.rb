# frozen_string_literal: true

describe Object do
  describe 'yard' do
    describe '#is_any?' do
      context 'when none match' do
        it do
          object = [1, 2, 3]

          expect(object.is_any?(Hash, Class)).to eq(false)
          expect(object.is_any?(Hash, Array)).to eq(true)
        end
      end
    end
  end
end

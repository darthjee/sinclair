# frozen_string_literal: true

require 'spec_helper'

describe Object do
  describe '#is_any?' do
    subject(:object) { 1 }

    it do
      expect(object).to respond_to(:is_any?)
    end

    context 'when no argument is passed' do
      it do
        expect(object).not_to be_is_any
      end
    end

    context 'when passing the correct class as argument' do
      it do
        expect(object).to be_is_any(object.class)
      end

      context 'when passing any other class' do
        it do
          expect(object).to be_is_any(Symbol, object.class)
        end
      end
    end

    context 'when passing the wrong class' do
      it do
        expect(object).not_to be_is_any(Symbol)
      end
    end
  end
end

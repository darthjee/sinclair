# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Caster::ClassMethods do
  subject(:caster) { Class.new(superclass) }

  let(:superclass) do
    Class.new(Sinclair::Caster) do
      cast_with(:string, :to_s)
      cast_with(:integer, :to_i)
      cast_with(:float, :to_f)
    end
  end

  describe '.cast_with' do
    let(:value)       { instance_double('value', to_p: final_value) }
    let(:final_value) { Random.rand(100) }

    context 'when a proc is given' do
      it do
        expect { caster.cast_with(:problem, &:to_p) }
          .not_to raise_error
      end

      context 'when casting is called' do
        before { caster.cast_with(:problem, &:to_p) }

        it 'returns the cast value' do
          expect(caster.cast(value, :problem)).to eq(final_value)
        end
      end
    end

    context 'when a proc with two arguments is given' do
      it do
        expect { caster.cast_with(:problem) { |v, **_opts| v.to_p } }
          .not_to raise_error
      end

      context 'when casting is called' do
        before { caster.cast_with(:problem) { |v, sum:| v.to_p + sum } }

        it 'returns the cast value' do
          expect(caster.cast(value, :problem, sum: 2))
            .to eq(final_value + 2)
        end
      end
    end

    context 'when a symbol is given' do
      let(:instance) { Sinclair::Caster.new(&:to_p) }

      it do
        expect { caster.cast_with(:problem, instance) }
          .not_to raise_error
      end

      context 'when casting is called' do
        before { caster.cast_with(:problem, instance) }

        it 'returns the cast value' do
          expect(caster.cast(value, :problem)).to eq(final_value)
        end
      end
    end

    context 'when a caster is given is given' do
      it do
        expect { caster.cast_with(:problem, :to_p) }
          .not_to raise_error
      end

      context 'when casting is called' do
        before { caster.cast_with(:problem, :to_p) }

        it 'returns the cast value' do
          expect(caster.cast(value, :problem)).to eq(final_value)
        end
      end
    end

    context 'when key is a class' do
      it do
        expect { caster.cast_with(Integer, :to_i) }
          .not_to raise_error
      end

      context 'when casting is called' do
        before { caster.cast_with(Integer, :to_i) }

        it 'returns the cast value' do
          expect(caster.cast('10', Integer)).to eq(10)
        end
      end
    end

    context 'when key is a module' do
      it do
        expect { caster.cast_with(JSON) { |value| JSON.parse(value) } }
          .not_to raise_error
      end

      context 'when casting is called' do
        before { caster.cast_with(JSON) { |value| JSON.parse(value) } }

        it 'returns the cast value' do
          expect(caster.cast('{"key":"value"}', JSON))
            .to eq({ 'key' => 'value' })
        end
      end
    end

    context 'when key is a superclass' do
      it do
        expect { caster.cast_with(Numeric, :to_i) }
          .not_to raise_error
      end

      context 'when casting is called with the child class' do
        before { caster.cast_with(Numeric, :to_i) }

        it 'returns the cast value' do
          expect(caster.cast('10', Integer)).to eq(10)
        end
      end
    end
  end

  describe '.caster_for' do
    context 'when the key has been defined with a symbol key' do
      before { caster.cast_with(:problem, :to_p) }

      it do
        expect(caster.caster_for(:problem))
          .to be_a(Sinclair::Caster)
      end
    end

    context 'when the key has not been defined' do
      it do
        expect(caster.caster_for(:problem))
          .to be_a(Sinclair::Caster)
      end
    end
  end

  describe '.cast' do
    let(:value) { values.sample }
    let(:values) do
      [Random.rand, 'some string', { key: 10 }, Object.new, Class.new, [2, 3]]
    end

    context 'when klass is nil' do
      it 'returns the value' do
        expect(caster.cast(value, nil))
          .to eq(value)
      end
    end

    context 'when class is :string' do
      it 'returns the value as string' do
        expect(caster.cast(value, :string))
          .to eq(value.to_s)
      end
    end

    context 'when class is :integer' do
      let(:value) { '10.5' }

      it 'returns the value as integer' do
        expect(caster.cast(value, :integer))
          .to eq(10)
      end
    end

    context 'when class is :float' do
      let(:value) { '10.5' }

      it 'returns the value as float' do
        expect(caster.cast(value, :float))
          .to eq(10.5)
      end
    end
  end

  describe '.master_caster!' do
    it 'ignores superclass registered casters' do
      expect { caster.master_caster! }
        .to change { caster.cast('10', :integer) }
        .from(10).to('10')
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Config::ClassMethods do
  subject(:child_klass) { Class.new(klass) }

  let(:klass) do
    Class.new { extend Sinclair::Config::ClassMethods }
  end

  describe '.add_attributes' do
    let(:attributes) { [:username, 'password', :key] }

    it 'adds symbol attributes to class attributes' do
      expect { klass.add_attributes(*attributes) }
        .to change(klass, :attributes)
        .from([]).to(%i[username password key])
    end

    context 'when class already has attributes' do
      before do
        klass.add_attributes('email')
      end

      it 'adds new attributes' do
        expect { klass.add_attributes(*attributes) }
          .to change(klass, :attributes)
          .from([:email]).to(%i[email username password key])
      end
    end

    context 'when attributes have already been added' do
      before do
        klass.add_attributes('username', :password)
      end

      it 'adds new attributes' do
        expect { klass.add_attributes(*attributes) }
          .to change(klass, :attributes)
          .from(%i[username password])
          .to(%i[username password key])
      end
    end

    context 'when there is a child class' do
      it 'adds attributes to child class' do
        expect { klass.add_attributes(*attributes) }
          .to change(child_klass, :attributes)
          .from([]).to(%i[username password key])
      end

      context 'when child class already has attributes' do
        before do
          child_klass.add_attributes('email')
        end

        it 'adds new attributes to child class' do
          expect { klass.add_attributes(*attributes) }
            .to change(child_klass, :attributes)
            .from([:email]).to(%i[username password key email])
        end
      end

      context 'when child class already has one of the attributes' do
        before do
          child_klass.add_attributes(:email, 'username')
        end

        it 'adds new attributes to child class' do
          expect { klass.add_attributes(*attributes) }
            .to change(child_klass, :attributes)
            .from(%i[email username]).to(%i[username password key email])
        end
      end
    end

    context 'when there is a parent class' do
      it 'does not add attributes to parent class' do
        expect { child_klass.add_attributes(*attributes) }
          .not_to change(klass, :attributes)
      end

      context 'when parent already has attributes' do
        before do
          klass.add_attributes(:email, 'username')
        end

        it 'adds only attributes that had not been defined before' do
          expect { child_klass.add_attributes(*attributes) }
            .to change(child_klass, :attributes)
            .from(%i[email username]).to(%i[email username password key])
        end
      end
    end
  end

  describe 'attributes' do
    context 'after adding attributes' do
      xit 'returns added attributes'
    end

    context 'when parent class has attributes' do
      xit 'returns parents attributes also'
    end

    context 'when parent class changes its attributes' do
      xit 'returns adds new attributes to self'
    end
  end
end

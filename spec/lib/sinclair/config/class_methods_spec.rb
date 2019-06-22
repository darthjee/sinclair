# frozen_string_literal: true

require 'spec_helper'

describe Sinclair::Config::ClassMethods do
  subject(:klass) do
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
  end
end

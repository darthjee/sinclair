# frozen_string_literal: true

shared_examples 'a config class with .add_attributes method' do
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
      klass.add_attributes(*attributes)
      expect(child_klass.attributes)
        .to eq(%i[username password key])
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

shared_examples 'a config class with .attributes method' do
  let(:attributes) { [:username, 'password', :key] }

  context 'when attributes have been added' do
    before { klass.add_attributes(*attributes) }

    it 'returns added attributes' do
      expect(klass.attributes).to eq(%i[username password key])
    end
  end

  context 'when parent class has attributes' do
    before { klass.add_attributes(*attributes) }

    it 'returns parents attributes also' do
      expect(child_klass.attributes).to eq(%i[username password key])
    end
  end

  context 'when parent class changes its attributes' do
    it 'does not change child class' do
      expect { klass.add_attributes(*attributes) }
        .not_to change(child_klass, :attributes)
    end
  end
end

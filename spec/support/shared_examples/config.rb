# frozen_string_literal: true

shared_examples 'a config class with .config_attributes method' do
  let(:attributes) { [:username, 'password', :key] }

  describe 'setting the attributes' do
    it 'adds symbol attributes to class attributes' do
      expect { klass.config_attributes(*attributes) }
        .to change(klass, :config_attributes)
        .from([]).to(%i[username password key])
    end

    context 'when class already has attributes' do
      before do
        klass.config_attributes('email')
      end

      it 'adds new attributes' do
        expect { klass.config_attributes(*attributes) }
          .to change(klass, :config_attributes)
          .from([:email]).to(%i[email username password key])
      end
    end

    context 'when attributes have already been added' do
      before do
        klass.config_attributes('username', :password)
      end

      it 'adds new attributes' do
        expect { klass.config_attributes(*attributes) }
          .to change(klass, :config_attributes)
          .from(%i[username password])
          .to(%i[username password key])
      end
    end

    context 'when there is a child class' do
      it 'adds attributes to child class' do
        expect { klass.config_attributes(*attributes) }
          .to change(child_klass, :config_attributes)
          .from([]).to(%i[username password key])
      end

      context 'when child class already has attributes' do
        before do
          child_klass.config_attributes('email')
        end

        it 'adds new attributes to child class' do
          expect { klass.config_attributes(*attributes) }
            .to change(child_klass, :config_attributes)
            .from([:email]).to(%i[username password key email])
        end
      end

      context 'when child class already has one of the attributes' do
        before do
          child_klass.config_attributes(:email, 'username')
        end

        it 'adds new attributes to child class' do
          expect { klass.config_attributes(*attributes) }
            .to change(child_klass, :config_attributes)
            .from(%i[email username]).to(%i[username password key email])
        end
      end
    end

    context 'when there is a parent class' do
      it 'does not add attributes to parent class' do
        expect { child_klass.config_attributes(*attributes) }
          .not_to change(klass, :config_attributes)
      end

      context 'when parent already has attributes' do
        before do
          klass.config_attributes(:email, 'username')
        end

        it 'adds only attributes that had not been defined before' do
          expect { child_klass.config_attributes(*attributes) }
            .to change(child_klass, :config_attributes)
            .from(%i[email username]).to(%i[email username password key])
        end
      end
    end
  end

  describe 'retrieving the attributes' do
    let(:attributes) { [:username, 'password', :key] }

    context 'when attributes have been added' do
      before { klass.config_attributes(*attributes) }

      it 'returns added attributes' do
        expect(klass.config_attributes).to eq(%i[username password key])
      end
    end

    context 'when parent class has attributes' do
      before { klass.config_attributes(*attributes) }

      it 'returns parents attributes also' do
        expect(child_klass.config_attributes).to eq(%i[username password key])
      end
    end

    context 'when parent class changes its attributes' do
      it 'returns adds new attributes to self' do
        expect { klass.config_attributes(*attributes) }
          .to change(child_klass, :config_attributes)
          .from([]).to(%i[username password key])
      end
    end
  end
end

shared_examples 'a config class with .add_configs method' do
  let(:setter_block) do
    proc { |value| config.instance_variable_set(:@name, value) }
  end

  it_behaves_like 'a config methods builder adding config' do
    let(:code_block) { proc { klass.add_configs(:name) } }

    it 'sets nil value by default' do
      code_block.call
      expect(config.name).to be_nil
    end

    it 'adds attributes to class' do
      expect(&code_block).to change(klass, :config_attributes)
        .from([]).to(%i[name])
    end

    it do
      expect(&code_block)
        .to add_method(:name)
        .to(klass.options_class)
    end
  end

  context 'when giving defaults' do
    it_behaves_like 'a config methods builder adding config' do
      let(:code_block) { proc { klass.add_configs(name: 'Bob') } }

      it 'sets default value' do
        code_block.call
        expect(config.name).to eq('Bob')
      end

      it 'adds attributes to class' do
        expect(&code_block).to change(klass, :config_attributes)
          .from([]).to(%i[name])
      end

      it do
        expect(&code_block)
          .to add_method(:name)
          .to(klass.options_class)
      end
    end

    context 'when there is a child class' do
      let(:code_block) { proc { klass.add_configs(name: 'Bob') } }

      it 'adds attributes to child class' do
        expect(&code_block)
          .to change(child_klass, :config_attributes)
          .from([]).to(%i[name])
      end

      context 'when child class already has attributes' do
        before do
          child_klass.add_configs('email')
        end

        it 'adds new attributes to child class' do
          expect(&code_block)
            .to change(child_klass, :config_attributes)
            .from([:email]).to(%i[name email])
        end
      end
    end
  end
end

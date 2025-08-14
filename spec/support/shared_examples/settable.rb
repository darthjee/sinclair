# frozen_string_literal: true

shared_examples 'settings reading' do
  let(:env_hash) { ENV }

  context 'when the key is not set' do
    after do
      env_hash.delete(username_key)
      env_hash.delete(password_key)
    end

    it 'retrieves username from env' do
      expect(settable.username).to be_nil
    end

    it 'retrieves password from env' do
      expect(settable.password).to be_nil
    end

    it 'cache username from env' do
      expect { env_hash[username_key] = SecureRandom.hex }
        .to_not change { settable.username }
    end

    it 'cache password from env' do
      expect { env_hash[password_key] = SecureRandom.hex }
        .to_not change { settable.password }
    end
  end

  context 'when the key is set' do
    before do
      env_hash[username_key] = username
      env_hash[password_key] = password
    end

    after do
      env_hash.delete(username_key)
      env_hash.delete(password_key)
    end

    it 'retrieves username from env' do
      expect(settable.username).to eq(username)
    end

    it 'retrieves password from env' do
      expect(settable.password).to eq(password)
    end

    it 'cache username from env' do
      expect { env_hash[username_key] = SecureRandom.hex }
        .to_not change { settable.username }
    end

    it 'cache password from env' do
      expect { env_hash[password_key] = SecureRandom.hex }
        .to_not change { settable.password }
    end
  end

  context 'when defining defaults' do
    let(:settings)   { %i[host] }
    let(:options)    { { prefix:, default: 'my-host.com' } }

    it 'returns default value' do
      expect(settable.host).to eq('my-host.com')
    end

    context 'when setting the env variable' do
      let(:other_host) { 'other-host.com' }

      before do
        env_hash[host_key] = other_host
      end

      after do
        env_hash.delete(host_key)
      end

      it 'retrieves host from env' do
        expect(settable.host).to eq(other_host)
      end
    end
  end

  context 'when defining a type' do
    let(:settings) { %i[port] }
    let(:options)  { { prefix:, type: :integer } }
    let(:port)     { Random.rand(10..100) }

    context 'when the key is not set' do
      it 'retrieves port and cast to string' do
        expect(settable.port).to be_nil
      end
    end

    context 'when the key is set' do
      before do
        env_hash[port_key] = port.to_s
      end

      after do
        env_hash.delete(port_key)
      end

      it 'retrieves port and cast to string' do
        expect(settable.port).to eq(port)
      end
    end
  end
end

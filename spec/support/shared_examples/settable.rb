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
        .not_to(change(settable, :username))
    end

    it 'cache password from env' do
      expect { env_hash[password_key] = SecureRandom.hex }
        .not_to(change(settable, :password))
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
        .not_to(change(settable, :username))
    end

    it 'cache password from env' do
      expect { env_hash[password_key] = SecureRandom.hex }
        .not_to(change(settable, :password))
    end
  end

  context 'when defining defaults' do
    let(:settings)   { %i[host] }
    let(:options)    { { prefix:, default: 'my-host.com' } }

    after do
      env_hash.delete(host_key)
    end

    context 'when not setting the env variable' do
      it 'returns default value' do
        expect(settable.host).to eq('my-host.com')
      end

      it 'caches default value' do
        expect { env_hash[host_key] = SecureRandom.hex }
          .not_to(change(settable, :host))
      end
    end

    context 'when setting the env variable' do
      let(:other_host) { 'other-host.com' }

      before do
        env_hash[host_key] = other_host
      end

      it 'retrieves host from env' do
        expect(settable.host).to eq(other_host)
      end

      it 'caches env value' do
        expect { env_hash[host_key] = SecureRandom.hex }
          .not_to(change(settable, :host))
      end
    end
  end

  context 'when defining a type' do
    let(:settings) { %i[port] }
    let(:options)  { { prefix:, type: :integer } }
    let(:port)     { Random.rand(10..100) }
    let(:new_port) { Random.rand(1000..10000) }

    after do
      env_hash.delete(port_key)
    end

    context 'when the key is not set' do
      it 'retrieves port and cast to string' do
        expect(settable.port).to be_nil
      end

      it 'caches port as nil' do
        expect { env_hash[port_key] = new_port.to_s }
          .not_to(change(settable, :port))
      end
    end

    context 'when the key is set' do
      before do
        env_hash[port_key] = port.to_s
      end

      it 'retrieves port and cast to string' do
        expect(settable.port).to eq(port)
      end

      it 'caches port as integer' do
        expect { env_hash[port_key] = new_port.to_s }
          .not_to(change(settable, :port))
      end
    end
  end

  context 'when defining cache type as true' do
    let(:settings)      { %i[domain] }
    let(:options)       { { prefix:, cached: true } }
    let(:options_hash)  { { prefix:, cached: true } }
    let(:domain)        { 'example.com' }
    let(:new_domain)    { 'new-example.com' }

    after do
      env_hash.delete(domain_key)
    end

    context 'when the key is not set' do
      it 'retrieves domain and cast to string' do
        expect(settable.domain).to be_nil
      end

      it 'does not caches domain as nil' do
        expect { env_hash[domain_key] = new_domain.to_s }
          .to change(settable, :domain)
          .from(nil).to(new_domain)
      end
    end

    context 'when the key is set' do
      before do
        env_hash[domain_key] = domain.to_s
      end

      it 'retrieves domain and cast to string' do
        expect(settable.domain).to eq(domain)
      end

      it 'caches domain as string' do
        expect { env_hash[domain_key] = new_domain }
          .not_to(change(settable, :domain))
      end
    end
  end
end

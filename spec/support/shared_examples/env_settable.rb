# frozen_string_literal: true

shared_examples 'settings reading from env' do
  let(:env_hash) { ENV }

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

  context 'when defining defaults' do
    let(:settings)   { %i[host] }
    let(:options)    { { prefix: prefix, default: 'my-host.com' } }

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
end

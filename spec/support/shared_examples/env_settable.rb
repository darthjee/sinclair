# frozen_string_literal: true

shared_examples 'settings reading from env' do
  before do
    ENV[username_key] = username
    ENV[password_key] = password
  end

  after do
    ENV.delete(username_key)
    ENV.delete(password_key)
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
        ENV[host_key] = other_host
      end

      after do
        ENV.delete(host_key)
      end

      it 'retrieves host from env' do
        expect(settable.host).to eq(other_host)
      end
    end
  end
end

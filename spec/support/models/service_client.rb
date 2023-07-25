# frozen_string_literal: true

class ServiceClient
  extend Sinclair::EnvSettable
  attr_reader :username, :password, :host, :port

  settings_prefix 'SERVICE'

  with_settings :username, :password, port: 80, hostname: 'my-host.com'

  def self.default
    @default ||= new
  end

  def initialize(
    username: self.class.username,
    password: self.class.password,
    port: self.class.port,
    hostname: self.class.hostname
  )
    @username = username
    @password = password
    @port = port
    @hostname = hostname
  end
end

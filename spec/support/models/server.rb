# frozen_string_literal: true

require './spec/support/models/default_valueable'

class Server
  extend DefaultValueable

  attr_writer :host, :port

  default_reader :host, value: 'server.com', accept_nil: false
  default_reader :port, value: 80,           accept_nil: true

  def url
    return "http://#{host}" unless port

    "http://#{host}:#{port}"
  end
end

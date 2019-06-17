# frozen_string_literal: true

module DefaultValueable
  def default_reader(*methods, value:, accept_nil: false)
    DefaultValueBuilder.new(
      self, value: value, accept_nil: accept_nil
    ).add_default_values(*methods)
  end
end

class DefaultValueBuilder < Sinclair
  def add_default_values(*methods)
    default_value = value

    methods.each do |method|
      add_method(method, cached: cache_type) { default_value }
    end

    build
  end

  private

  delegate :accept_nil, :value, to: :options_object

  def cache_type
    accept_nil ? :full : :simple
  end
end

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

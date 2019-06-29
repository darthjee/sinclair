# frozen_string_literal: true

class MyServerConfig < Sinclair::Config
  add_attributes :host, :port

  def url
    if @port
      "http://#{@host}:#{@port}"
    else
      "http://#{@host}"
    end
  end
end

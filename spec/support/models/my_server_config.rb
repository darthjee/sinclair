# frozen_string_literal: true

class MyServerConfig
  def url
    if @port
      "http://#{@host}:#{@port}"
    else
      "http://#{@host}"
    end
  end
end

# frozen_string_literal: true

class ConnectionOptions < Sinclair::Options
  with_options :timeout, :retries, port: 443, protocol: 'https'
end

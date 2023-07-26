# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Module to be extended allowing configurations from environment
  #
  # @example
  #   class MyAppClient
  #     extend Sinclair::EnvSettable
  #
  #     settings_prefix 'MY_APP'
  #
  #     with_settings :username, :password, host: 'my-host.com'
  #     setting_with_options :port, type: :integer
  #   end
  #
  #   ENV['MY_APP_USERNAME'] = 'my_login'
  #   ENV['MY_APP_PORT']     = '8080'
  #
  #   MyAppClient.username # returns 'my_login'
  #   MyAppClient.password # returns nil
  #   MyAppClient.host     # returns 'my-host.com'
  #   MyAppClient.port     # returns 8080
  module EnvSettable
    include Sinclair::Settable
    extend Sinclair::Settable::ClassMethods

    read_with do |key, default: nil, prefix: nil|
      env_key = [prefix, key].compact.join('_').to_s.upcase

      ENV[env_key] || default
    end

    private

    # @private
    # @api public
    # @visibility public
    #
    # Sets environment keys prefix
    #
    # @param prefix [String] prefix of the env keys
    #
    # @return [String]
    #
    # @example (see EnvSettable)
    def settings_prefix(prefix = nil)
      return @settings_prefix || superclass_prefix unless prefix

      @settings_prefix = prefix
    end

    # @private
    #
    # Default options when creating the method
    #
    # Prefix is included in default options
    #
    # @return [Hash]
    def default_options
      super.merge(
        prefix: settings_prefix
      )
    end

    # @private
    #
    # Returns the prefix set up for a superclass
    #
    # This ensures that an inherited class also has a prefix
    #
    # @return [String]
    def superclass_prefix
      return unless superclass.is_a?(Sinclair::EnvSettable)

      superclass.settings_prefix
    end
  end
end

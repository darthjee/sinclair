# frozen_string_literal: true

class Sinclair
  # @api public
  # @author Darthjee
  #
  # Base options class
  #
  # @example Options usage
  #   class ConnectionOptions < Sinclair::Options
  #     with_options :timeout, :retries, port: 443, protocol: 'https'
  #   end
  #
  #   options = ConnectionOptions.new(retries: 10, port: 8080)
  #
  #   options.timeout  # returns nil
  #   options.retries  # returns 10
  #   options.port     # returns 8080
  #   options.protocol # returns 'https'
  class Options
    autoload :Builder, 'sinclair/options/builder'

    class << self
      # @api private
      #
      # Options allowed when initializing options
      #
      # @return [Array<Symbol>]
      def allowed_options
        @allowed_options ||= []
      end

      private

      # @api public
      # @!visibility public
      #
      # Add available options
      #
      # @example (see Options)
      #
      # @return (see Sinclair#build)
      def with_options(*options)
        Builder.new(self, *options).build
      end
    end

    # @param options [Hash] hash with options (see {.options}, {.with_options})
    # @example (see Options)
    def initialize(options = {})
      check_options(options)

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    private

    # @private
    # @api private
    #
    # check if given options are allowed
    #
    # @raise Sinclair::Exception::InvalidOptions
    #
    # @return [NilClass]
    def check_options(options)
      invalid_keys = options.keys - self.class.allowed_options

      return if invalid_keys.empty?

      raise Sinclair::Exception::InvalidOptions, invalid_keys
    end
  end
end

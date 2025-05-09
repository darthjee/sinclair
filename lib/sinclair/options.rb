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
    autoload :Builder,      'sinclair/options/builder'
    autoload :ClassMethods, 'sinclair/options/class_methods'

    extend ClassMethods
    include Comparable

    # @param options [Hash] hash with options (see {.options}, {.with_options})
    # @example (see Options)
    def initialize(options = {})
      check_options(options)

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    # Returns a hash with the current options
    #
    # @return [Hash]
    #
    # @example
    #   class ConnectionOptions < Sinclair::Options
    #     with_options :timeout, :retries, port: 443, protocol: 'https'
    #   end
    #
    #   options = ConnectionOptions.new(retries: 10, port: 8080)
    #
    #   options.to_h # returns
    #                # {
    #                #   port: 8080,
    #                #   retries: 10,
    #                #   timeout: nil,
    #                #   protocol: 'https'
    #                # }
    def to_h
      allowed_options.inject({}) do |hash, option|
        hash.merge(option => public_send(option))
      end
    end

    private

    delegate :allowed_options, :skip_validation?, :invalid_options_in, to: :class

    # @private
    # @api private
    #
    # check if given options are allowed
    #
    # @raise Sinclair::Exception::InvalidOptions
    #
    # @return [NilClass]
    def check_options(options)
      return if skip_validation?

      invalid_keys = invalid_options_in(options.keys)

      return if invalid_keys.empty?

      raise Sinclair::Exception::InvalidOptions, invalid_keys
    end
  end
end

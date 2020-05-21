# frozen_string_literal: true

require 'set'

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
      # returns invalid options
      #
      # @return [Array<Symbol>]
      def invalid_options_in(names)
        names.map(&:to_sym) - allowed_options.to_a
      end

      # @api private
      #
      # Allow new option
      #
      # This does not create the method
      #
      # @param name [String,Symbol] options to be allowed
      #
      # @return [Set<Symbol>]
      def allow(name)
        allowed_options << name.to_sym
      end

      # @api private
      # @private
      #
      # Options allowed when initializing options
      #
      # @return [Set<Symbol>]
      def allowed_options
        @allowed_options ||= superclass.try(:allowed_options).dup || Set.new
      end

      # @api private
      #
      # checks if class skips initialization validation
      #
      # @return [TrueClass,FalseClass]
      def skip_validation?
        @skip_validation ||= superclass.try(:skip_validation?) || false
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
      #
      # @overload with_options(*options)
      #   @param options [Array<Symbol>] list of accepted
      #     options
      # @overload with_options(*options, **defaults)
      #   @param options [Array<Symbol>] list of accepted
      #     options
      #   @param defaults [Hash<Symbol,Object>] default options
      #     hash
      def with_options(*options)
        Builder.new(self, *options).build
      end

      # @api public
      # @!visibility public
      #
      # Changes class to skip attributes validation
      #
      # when initializing options, options
      # will accept any arguments when validation
      # is skipped
      #
      # @return [TrueClass]
      #
      # @example
      #   class BuilderOptions < Sinclair::Options
      #     with_options :name
      #
      #     skip_validation
      #   end
      #   options = BuilderOptions.new(name: 'Joe', age: 10)
      #
      #   options.name      # returns 'Joe'
      #   options.try(:age) # returns nil
      def skip_validation
        @skip_validation = true
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
      self.class.allowed_options.inject({}) do |hash, option|
        hash.merge(option => public_send(option))
      end
    end

    # returns if other equals to self
    #
    # @param other [Object] object to be compared
    #
    # @return [TrueClass,FalseClass]
    def ==(other)
      return false unless self.class == other.class

      self.class.allowed_options.all? do |name|
        public_send(name) == other.public_send(name)
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
      return if self.class.skip_validation?

      invalid_keys = self.class.invalid_options_in(options.keys)

      return if invalid_keys.empty?

      raise Sinclair::Exception::InvalidOptions, invalid_keys
    end
  end
end

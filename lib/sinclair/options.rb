# frozen_string_literal: true

class Sinclair
  # @api public
  # @author Darthjee
  #
  # Base options class
  #
  # @example Options usage
  #   options = ConnectionOptions.new(retries: 10, port: 8080)
  #
  #   expect(options.timeout).to be_nil
  #   expect(options.retries).to eq(10)
  #   expect(options.port).to eq(8080)
  #   expect(options.protocol).to eq('https')
  class Options
    autoload :Builder, 'sinclair/options/builder'

    class << self
      def options
        @options ||= []
      end

      private

      def with_options(*options)
        Builder.new(self, *options).build
      end
    end

    # @param options [Hash] hash with options (see {.options}, {.with_options})
    def initialize(options = {})
      check_options(options)

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    private

    # @private
    #
    # check if given options are allowed
    #
    # @raise Sinclair::Exception::InvalidOptions
    #
    # @return [NilClass]
    def check_options(options)
      invalid_keys = options.keys - self.class.options

      return if invalid_keys.empty?

      raise Sinclair::Exception::InvalidOptions, invalid_keys
    end
  end
end

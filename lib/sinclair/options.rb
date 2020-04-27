# frozen_string_literal: true

class Sinclair
  class Options
    class << self
      def options
        @options ||= []
      end

      private

      def with_options(*options)
        builder = Sinclair.new(self)

        options.each do |option|
          builder.add_method(option, cached: true) { nil }
          self.options.push(option)
        end

        builder.build
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

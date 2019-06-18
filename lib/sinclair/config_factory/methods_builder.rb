# frozen_string_literal: true

class Sinclair
  class ConfigFactory
    class MethodsBuilder < Sinclair
      def initialize(klass, *names)
        super(klass)

        @names = names
        @defaults = names.find { |arg| arg.is_a?(Hash) } || {}
        names.delete(defaults)
      end

      def build
        config_hash.each do |method, value|
          add_method(method, cached: :full) { value }
        end

        super
      end

      def config_names
        config_hash.keys
      end

      private

      attr_reader :names, :defaults

      def config_hash
        @config_hash ||= names_as_hash.merge!(defaults)
      end

      def names_as_hash
        Hash[names.map { |*name| name }]
      end
    end
  end
end

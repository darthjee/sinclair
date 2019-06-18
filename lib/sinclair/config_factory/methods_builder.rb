# frozen_string_literal: true

class Sinclair
  class ConfigFactory
    class MethodsBuilder < Sinclair
      def initialize(klass, *arguments)
        super(klass)
        @arguments = arguments
      end

      def build
        hash.each do |method, value|
          add_method(method, cached: :full) { value }
        end

        super
      end

      def config_names
        hash.keys
      end

      private

      attr_reader :arguments

      def hash
        @hash ||= name_hash.merge!(default_hash)
      end

      def default_hash
        hash_arguments.inject({}) do |hash, argument|
          hash.merge! argument
        end
      end

      def name_hash
        Hash[name_arguments.map { |a| [a] }]
      end

      def hash_arguments
        arguments.select { |arg| arg.is_a?(Hash) }
      end

      def name_arguments
        arguments.reject { |arg| arg.is_a?(Hash) }
      end
    end
  end
end

# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Module responsible for building instance method definition
    module InstanceMethodDefinition
      # Returns an instance method definition
      #
      # When block is given returns an instance of
      # {InstanceBlockDefinition}, and when not, returns
      # {InstanceStringDefinition}
      #
      # @param name    [String,Symbol] name of the method
      # @param code    [String] code to be evaluated as method
      # @param block   [Proc] block with code to be added as method
      # @param options [Hash] Options of construction
      # @option options cached [Boolean] Flag telling to create
      #   a method with cache
      #
      # @example
      #   klass = Class.new
      #
      #   method_definition = Sinclair::MethodDefinition::InstanceMethodDefinition.from(
      #     :sequence, '@x = @x.to_i ** 2 + 1', klass
      #   )
      #
      #   method_definition.build(klass)
      #
      #   instance = klass.new
      #
      #   instance.sequence # returns 1
      #   instance.sequence # returns 2
      #   instance.sequence # returns 5
      def self.from(name, code = nil, **options, &block)
        if block
          InstanceBlockDefinition.new(name, **options, &block)
        else
          InstanceStringDefinition.new(name, code, **options)
        end
      end
    end
  end
end

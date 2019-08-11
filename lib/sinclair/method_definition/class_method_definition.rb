# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Module responsible for building class method definitions
    module ClassMethodDefinition
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
      #
      # @return MethodDefinition
      def self.from(name, code = nil, **options, &block)
        if block
          ClassBlockDefinition.new(name, **options, &block)
        else
          ClassStringDefinition.new(name, code, **options)
        end
      end
    end
  end
end

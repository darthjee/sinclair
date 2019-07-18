# frozen_string_literal: true

class Sinclair
  class MethodDefinition
    # @api private
    # @author darthjee
    #
    # Builder capable of adding methods to instances
    class InstanceMethodDefinition < MethodDefinition
      # Creates a new instance based on arguments
      #
      # @return [InstanceMethodDefinition] When block is given, a
      #   new instance of {InstanceBlockDefinition} is returned,
      #   otherwise {InstanceStringDefinition} is returned
      def self.from(name, code = nil, **options, &block)
        if block
          InstanceBlockDefinition.new(name, **options, &block)
        else
          InstanceStringDefinition.new(name, code, **options)
        end
      end

      # Adds the method to given klass
      #
      # This should be implemented on child classes
      #
      # @param _klass [Class] class which will receive the new method
      #
      # @example (see MethodDefinition::InstanceBlockDefinition#build)
      # @example (see MethodDefinition::InstanceStringDefinition#build)
      #
      # @return [Symbol] name of the created method
      def build(_klass)
        raise 'Build is implemented in subclasses. ' \
          "Use #{self.class}.from to initialize a proper object"
      end
    end
  end
end

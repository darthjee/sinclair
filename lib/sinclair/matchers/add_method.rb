# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    #
    # Common methods for matchers
    class AddMethod < Base
      class << self
        private

        # @api private
        # @private
        #
        # Add a method to generate the final matcher
        #
        # @param name [String,Symbol] the name of the method
        # @param matcher_class [Class<AddMethodTo>] The matcher class to be returned
        #
        # @return (see Sinclair#build)
        #
        # @!macro with_final_matcher
        #   @!method $1(target = nil)
        #   @api public
        #
        #   Builds final matcher
        #
        #   The matcher checks if a method was added
        #   to a class or instance
        #
        #   @param [Class,Object] target where the method will be added
        #
        #   @return [$2]
        def with_final_matcher(name, matcher_class)
          matcher = matcher_class
          Sinclair.new(self).tap do |builder|
            builder.add_method(name) { |target| matcher.new(target, method_name) }
          end.build
        end
      end

      # @abstract
      #
      # Raise a warning on the usage as this is only a builder
      #
      # @raise SyntaxError
      def matches?(_actual)
        raise SyntaxError, matcher_error
      end
    end
  end
end

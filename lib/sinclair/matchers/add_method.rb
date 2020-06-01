# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    #
    # Commone methods for matchers
    module AddMethod
      # @api public
      #
      # Builds final matcher
      #
      # @return [Sinclair::Matchers::Base]
      def to(target = nil)
        add_method_to_class.new(target, method_name)
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

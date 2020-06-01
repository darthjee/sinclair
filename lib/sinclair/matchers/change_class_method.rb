# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of
    # {Sinclair::Matchers::ChangeClassMethodOn}
    class ChangeClassMethod < Base
      include AddMethod

      alias on to
      # @method on
      # @api public
      #
      # (see  AddMethod#to)

      private

      # @private
      #
      # Error description on wrong usage
      #
      # @return String
      def matcher_error
        'You should specify which class the method is being changed on' \
          "change_class_method(:#{method_name}).on(klass)"
      end

      # @private
      #
      # Class of the real matcher
      #
      # @return [Class<Sinclair::Matchers::Base>]
      def add_method_to_class
        ChangeClassMethodOn
      end
    end
  end
end

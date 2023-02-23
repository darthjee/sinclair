# frozen_string_literal: true

class Sinclair
  module Matchers
    # @api private
    # @author darthjee
    #
    # AddInstanceMethod is able to build an instance of
    # {Sinclair::Matchers::ChangeInstanceMethodOn}
    class ChangeInstanceMethod < AddMethod

      with_final_matcher :on, ChangeInstanceMethodOn

      private

      # @private
      #
      # Error description on wrong usage
      #
      # @return String
      def matcher_error
        'You should specify which instance the method is being changed on' \
          "change_method(:#{method_name}).on(instance)"
      end

      # @private
      #
      # Class of the real matcher
      #
      # @return [Class<Sinclair::Matchers::Base>]
      def add_method_to_class
        ChangeInstanceMethodOn
      end
    end
  end
end

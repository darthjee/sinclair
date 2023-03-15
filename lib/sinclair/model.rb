# frozen_string_literal: true

class Sinclair
  # @api public
  # @author Darthjee
  #
  # Basic model to be used when defining new classes quickly
  class Model
    autoload :Builder, 'sinclair/model/builder'

    class << self
      # Returns a new class that inherits from model
      #
      # @overload for(*attributes, writter: true)
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      # @overload for(*attributes, defaults, writter: true)
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param defaults [Hash] attributes to be added with a default value in the initializer
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #
      # @return [Class<Model>] a new class with the chosen attributes
      def for(*attributes, **options)
        Class.new(self) do |klass|
          Builder.new(klass, *attributes, **options).build
        end
      end
    end
  end
end

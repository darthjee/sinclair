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
      # @overload for(*attributes, writter: true, comparable: true)
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #   @param comparable [TrueClass,FalseClass] flag to make the class {Comparable}
      #     by the fields
      #
      #   @example A model with readers
      #     class Car < Sinclair::Model.for(:brand, :model, writter: false)
      #     end
      #
      #     car = Car.new(brand: :ford, model: :T)
      #
      #     car.brand # returns :ford
      #     car.model # returns :T
      #
      # @overload for(*attributes, defaults, writter: true, comparable: true)
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param defaults [Hash] attributes to be added with a default value in the initializer
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #   @param comparable [TrueClass,FalseClass] flag to make the class {Comparable}
      #     by the fields
      #
      #   @example A model with writters
      #     class Job < Sinclair::Model.for({ state: :starting }, writter: true)
      #     end
      #
      #     job = Job.new
      #
      #     job.state # returns :starting
      #     job.state = :done
      #     job.state # returns :done
      #
      # @return [Class<Model>] a new class with the chosen attributes
      def for(*attributes, **options)
        Class.new(self) do |klass|
          Builder.new(klass, *attributes, **options).build
        end
      end

      # @overload initialize_with(*attributes, writter: true, comparable: true)
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #   @param comparable [TrueClass,FalseClass] flag to make the class {Comparable}
      #     by the fields
      #
      # @overload initialize_with(*attributes, defaults, writter: true, comparable: true)
      #   @param attributes [Array<Symbol>] attributes to be added in both the
      #     initialization and adding the methos to the model
      #   @param defaults [Hash] attributes to be added with a default value in the initializer
      #   @param writter [TrueClass,FalseClass] flag informing if the writter/setter
      #     method should be added
      #   @param comparable [TrueClass,FalseClass] flag to make the class {Comparable}
      #     by the fields
      def initialize_with(*attributes, **options)
        Builder.new(self, *attributes, **options).build
      end
    end
  end
end

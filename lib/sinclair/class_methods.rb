# frozen_string_literal: true

class Sinclair
  # @author darthjee
  # @api public
  #
  # Class methods for {Sinclair}
  module ClassMethods
    # Runs build using a block for adding the methods
    #
    # The block is executed adding the methods and after the builder
    # runs build building all the methods
    #
    # @overload build(*args, **options, &block)
    #   @param (see Sinclair#initialize)
    #   @param block [Proc] block to be executed by the builder
    #     in order to add the methods before running build
    #
    # @yield an instance of a builder ({Sinclair})
    #
    # @return (see Sinclair#build)
    #
    # @example Simple usage
    #   class MyPerson
    #   end
    #
    #   Sinclair.build(model_class) do
    #     add_method(:random_name, cached: true) do
    #       "John #{Random.rand(1000)} Doe"
    #     end
    #   end
    #
    #   model = MyPerson.new
    #
    #   model.random_name # returns 'John 803 Doe'
    def build(*, **, &)
      new(*, **).tap do |builder|
        builder.instance_eval(&) if block_given?
      end.build
    end
  end
end

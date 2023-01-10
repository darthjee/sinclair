# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Class responsible for checking if two instances of a class are the equals
  #
  # @example regular usage
  #   checker = Sinclair::EqualsChecker.new(:name, :age)
  #
  #   model1 = SampleModel.new(name: 'jack', age: 21)
  #   model2 = SampleModel.new(name: 'rose', age: 23)
  #
  #   checker.match?(model1, model2) # returns false
  #
  # @example similar models
  #   checker = Sinclair::EqualsChecker.new(:name, :age)
  #
  #   model1 = SampleModel.new(name: 'jack', age: 21)
  #   model2 = SampleModel.new(name: 'jack', age: 21)
  #
  #   checker.match?(model1, model2) # returns true
  #
  # @example different classes
  #   checker = Sinclair::EqualsChecker.new(:name, :age)
  #
  #   model1 = SampleModel.new(name: 'jack', age: 21)
  #   model2 = OtherModel.new(name: 'jack', age: 21)
  #
  #   checker.match?(model1, model2) # returns false
  class EqualsChecker
    # @param attributes [Array<Symbol,String>] list of relevant attributes
    def initialize(*attributes)
      @attributes = attributes.flatten
    end

    # Returns if 2 objects are equals
    #
    # The check takes into consideration:
    #   - They should be instances of the same class
    #   - Their attributes (method calls) should return the same value,
    #   for the configured attributes
    #   - Public and private attributes are checked
    #
    # @example (see Sinclair::EqualsChecker)
    #
    # @return  [TrueClass,FalseClass]
    def match?(model, other)
      return false unless model.class == other.class

      attributes.all? do |attr|
        model.send(attr) == other.send(attr)
      end
    end

    private

    attr_reader :attributes

    # @private
    # @api private
    # @method attributes
    #
    # attributes relevant for checking difference
    #
    # @return [Array<Symbol,String>]
  end
end
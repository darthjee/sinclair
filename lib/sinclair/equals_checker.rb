# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Class responsible for checking if two instances of a class are the equals
  #
  # @example regular usage
  #   class SampleModel
  #     def initialize(name: nil, age: nil)
  #       @name = name
  #       @age  = age
  #     end
  #
  #     protected
  #
  #     attr_reader :name
  #
  #     private
  #
  #     attr_reader :age
  #   end
  #
  #   class OtherModel < SampleModel
  #   end
  #
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
      @attributes = Set.new(attributes.flatten)
    end

    # Adds new fields to equals checker
    #
    # @param attributes [Array<Symbol,String>] list of relevant attributes
    #
    # @return [Set<Symbol,String>]
    #
    # @example adding fields to equal checker
    #   checker = Sinclair::EqualsChecker.new(:name)
    #
    #   model1 = SampleModel.new(name: 'jack', age: 21)
    #   model2 = SampleModel.new(name: 'jack', age: 22)
    #
    #  checker.match?(model1, model2) # returns true
    #
    #  checker.add(:age)
    #
    #  checker.match?(model1, model2) # returns false
    def add(*attributes)
      @attributes += Set.new(attributes.flatten)
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
    # @return [Set<Symbol,String>]
  end
end

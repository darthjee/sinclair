# frozen_string_literal: true

# @api public
# @author darthjee
#
# Extension to core class Object
class Object
  # rubocop:disable Naming/PredicateName

  # @api public
  # Checks if an object is an instance of any of the given classes
  #
  # @param classes [Array<Class>] classes to be checked against object
  #
  # @example
  #   object = [1, 2, 3]
  #
  #   object.is_any?(Hash, Class) # returns false
  #   object.is_any?(Hash, Array) # returns true
  #
  # @return [TrueClass,FalseClass]
  def is_any?(*classes)
    classes.any?(method(:is_a?))
  end
  # rubocop:enable Naming/PredicateName
  
  def map_and_find
    mapped = nil
    find do |*args|
      mapped = yield(*args)
    end
    mapped || nil
  end
end

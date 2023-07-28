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

  # Maps the elements into a new value, returning only one
  #
  # The result to be returned is
  # the first mapping that is evaluated to true
  #
  # This method is equivalent to #map#find but
  # only calling the map block up to when a value
  # is found
  #
  # @yield (*args) mappig block
  #
  # @example Using an array of keys to remove remove elements of a hash
  #
  #   service_map = {
  #     a: nil,
  #     b: false,
  #     c: 'found me',
  #     d: nil,
  #     e: 'didnt find me'
  #   }
  #
  #   keys = %i[a b c d e]
  #
  #   keys.map_and_find do |key|   #
  #     service_values.delete(key) #
  #   end                          # returns 'found me'
  #
  #   service_map # has lost only 3 keys returning
  #               # { d: nil, e: 'didnt find me' }
  #
  # @return [::Object]
  def map_and_find
    mapped = nil
    find do |*args|
      mapped = yield(*args)
    end
    mapped || nil
  end
end

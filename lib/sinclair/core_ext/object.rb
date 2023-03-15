# frozen_string_literal: true

class Object
  # rubocop:disable Naming/PredicateName

  # Checks if an object is an instance of any of the given classes
  #
  # @param classes [Array<Class>] classes to be checked against object
  #
  # @return [TrueClass,FalseClass]
  def is_any?(*classes)
    classes.any?(method(:is_a?))
  end
  # rubocop:enable Naming/PredicateName
end

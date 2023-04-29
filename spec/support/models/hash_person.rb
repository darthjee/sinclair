# frozen_string_literal: true

class HashPerson < HashModel
  attr_accessor :name, :age

  def ==(other)
    return unless other.class == self.class

    other.name == name && other.age == age
  end
end

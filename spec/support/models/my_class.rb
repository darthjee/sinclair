class MyClass
  include MyConcern
  validate :name, :surname, String
  validate :age, :legs, Integer

  def initialize(name: nil, surname: nil, age: nil, legs: nil)
    @name = name
    @surname = surname
    @age = age
    @legs = legs
  end
end

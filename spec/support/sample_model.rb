class SampleModel
  attr_reader :name, :age

  def initialize(name: nil, age: nil)
    @name = name
    @age  = age
  end
end

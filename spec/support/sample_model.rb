class SampleModel
  def initialize(name: nil, age: nil)
    @name = name
    @age  = age
  end

  protected

  attr_reader :name

  private

  attr_reader :age
end

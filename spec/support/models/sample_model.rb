# frozen_string_literal: true

class SampleModel
  def initialize(name: nil, age: nil)
    @name = name
    @age  = age
  end

  def information
    "#{name}: #{age} yo"
  end

  protected

  attr_reader :name

  private

  attr_reader :age
end

class OtherModel < SampleModel
end

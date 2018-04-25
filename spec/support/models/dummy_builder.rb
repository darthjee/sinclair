class ConcernBuilder::Dummy
  def initialize
    @value = 0
  end
end

class ConcernBuilder::Dummy::Builder < ConcernBuilder
  def init
    add_method(:blocked) { 1 }
    add_method(:defined, "@value = @value + #{ options_object.try(:increment) || 1 }")
  end
end
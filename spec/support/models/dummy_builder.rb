class ConcernBuilder::DummyBuilder < ConcernBuilder
  def init
    add_method(:blocked) { 1 }
    add_method(:defined, "@value = value + #{ options_object.try(:increment) || 1 }")
    add_method(:value, "@value ||= 0")
  end
end

class Dummy
  Sinclair.new(self).tap do |builder|
    builder.add_method(:x) { 1 }
  end
end

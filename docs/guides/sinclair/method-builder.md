# Sinclair – Dynamic Method Builder

`Sinclair` lets you add instance and class methods to any class at runtime.
Methods are queued with `add_method` / `add_class_method` and created only
when `build` is called.

### Stand-alone usage

```ruby
class Clazz; end

builder = Sinclair.new(Clazz)
builder.add_method(:twenty, '10 + 10')          # string-based
builder.add_method(:eighty) { 4 * twenty }      # block-based
builder.add_class_method(:one_hundred) { 100 }
builder.build

instance = Clazz.new
instance.twenty        # => 20
instance.eighty        # => 80
Clazz.one_hundred      # => 100
```

### Block DSL (`Sinclair.build`)

```ruby
Sinclair.build(MyClass) do
  add_method(:random_number) { Random.rand(10..20) }
  add_class_method(:static_value) { 42 }
end
```

### String method with parameters

```ruby
Sinclair.build(MyClass) do
  add_class_method(
    :power, 'a ** b + c',
    parameters: [:a],
    named_parameters: [:b, { c: 15 }]
  )
end

MyClass.power(10, b: 2)       # => 115
MyClass.power(10, b: 2, c: 0) # => 100
```

### Call-based method (delegates to the class itself)

```ruby
builder = Sinclair.new(MyClass)
builder.add_class_method(:attr_accessor, :number, type: :call)
builder.build

MyClass.number      # => nil
MyClass.number = 10
MyClass.number      # => 10
```

### Caching results

```ruby
builder.add_method(:expensive, cached: true) { slow_computation }
# equivalent to: @expensive ||= slow_computation

builder.add_method(:nullable, cached: :full) { may_return_nil }
# caches even nil / false values
```

### Extending the builder

Subclass `Sinclair` to create domain-specific builders:

```ruby
class ValidationBuilder < Sinclair
  delegate :expected, to: :options_object

  def add_validation(field)
    add_method("#{field}_valid?", "#{field}.is_a?(#{expected})")
  end
end

module Validatable
  extend ActiveSupport::Concern

  class_methods do
    def validate(*fields, expected_class)
      builder = ValidationBuilder.new(self, expected: expected_class)
      fields.each { |f| builder.add_validation(f) }
      builder.build
    end
  end
end

class MyModel
  include Validatable
  validate :name, String
  validate :age, Integer
end
```

---

[Back to index](../sinclair-usage.md)

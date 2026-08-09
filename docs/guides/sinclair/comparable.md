# Sinclair::Comparable – Attribute-based Equality

Include `Sinclair::Comparable` and declare which attributes are used for `==`.

```ruby
class Person
  include Sinclair::Comparable

  comparable_by :name
  attr_reader :name, :age

  def initialize(name:, age:)
    @name = name
    @age  = age
  end
end

p1 = Person.new(name: 'Alice', age: 30)
p2 = Person.new(name: 'Alice', age: 25)

p1 == p2  # => true  (only :name is compared)
```

---

[Back to index](../sinclair-usage.md)

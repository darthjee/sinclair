# Sinclair::Caster – Type Casting

`Sinclair::Caster` provides a registry of named type casters.

```ruby
class MyCaster < Sinclair::Caster
  cast_with(:upcase, :upcase)
  cast_with(:log) { |value, base: 10| Math.log(value.to_f, base) }
end

MyCaster.cast('hello', :upcase)       # => 'HELLO'
MyCaster.cast(100, :log)              # => 2.0
MyCaster.cast(16, :log, base: 2)      # => 4.0
```

### Class-based casting

```ruby
class TypeCaster < Sinclair::Caster
  master_caster!

  cast_with(Integer, :to_i)
  cast_with(Float,   :to_f)
  cast_with(String,  :to_s)
end

TypeCaster.cast('42', Integer)  # => 42
TypeCaster.cast(3,    Float)    # => 3.0
```

---

[Back to index](../sinclair-usage.md)

Concern Builder
========

This gem helps the creation of complex concern with class methods

Getting started
---------------
1. Installation
  - Install it

  ```ruby
    gem install concern_buildern
  ```

  - Or add ConcernBuildern to your `Gemfile` and `bundle install`:

  ```ruby
    gem 'concern_builder'
  ```

  ```bash
    bundle install concern_builder
  ```

2. Using it:
The concern builder can actully be used in two ways, as an stand alone object capable of
adding methods to your class or by extending it for more complex logics

```ruby
  class Clazz
  end

  builder = ConcernBuilder.new(Clazz)

  builder.add_method(:twenty, '10 + 10')
  builder.add_method(:eighty) { 4 * twenty }
  builder.build

  instance = Clazz.new

  puts "Twenty => #{instance.twenty}"
  puts "Eighty => #{instance.eighty}"
```

Sinclair
========

![sinclair](https://raw.githubusercontent.com/darthjee/sinclair/master/sinclair.jpg)

This gem helps the creation of complex concern with class methods

Getting started
---------------
1. Installation
  - Install it

  ```ruby
    gem install sinclair
  ```

  - Or add Sinclairn to your `Gemfile` and `bundle install`:

  ```ruby
    gem 'sinclair'
  ```

  ```bash
    bundle install sinclair
  ```

2. Using it:
The concern builder can actully be used in two ways, as an stand alone object capable of
adding methods to your class or by extending it for more complex logics

 - Stand Alone usage:
```ruby
  class Clazz
  end

  builder = Sinclair.new(Clazz)

  builder.add_method(:twenty, '10 + 10')
  builder.add_method(:eighty) { 4 * twenty }
  builder.build

  instance = Clazz.new

  puts "Twenty => #{instance.twenty}"
  puts "Eighty => #{instance.eighty}"
```

```string
  Twenty => 20
  Eighty => 80
```

 - Extending the builder

  ```ruby
    class ValidationBuilder < Sinclair
      delegate :expected, to: :options_object

      def initialize(clazz, options={})
        super
      end

      def add_validation(field)
        add_method("#{field}_valid?", "#{field}.is_a?#{expected}")
      end

      def add_accessors(fields)
        clazz.send(:attr_accessor, *fields)
      end
    end

    module MyConcern
      extend ActiveSupport::Concern

      class_methods do
        def validate(*fields, expected_class)
          builder = ::ValidationBuilder.new(self, expected: expected_class)

          validatable_fields.concat(fields)
          builder.add_accessors(fields)

          fields.each do |field|
            builder.add_validation(field)
          end

          builder.build
        end

        def validatable_fields
          @validatable_fields ||= []
        end
      end

      def valid?
        self.class.validatable_fields.all? do |field|
          public_send("#{field}_valid?")
        end
      end
    end

    class MyClass
      include MyConcern
      validate :name, :surname, String
      validate :age, :legs, Integer

      def initialize(name: nil, surname: nil, age: nil, legs: nil)
        @name = name
        @surname = surname
        @age = age
        @legs = legs
      end
    end

    instance = MyClass.new
  ```

  the instance will respond to the methods
```name``` ```name=``` ```name_valid?```
```surname``` ```surname=``` ```surname_valid?```
```age``` ```age=``` ```age_valid?```
```legs``` ```legs=``` ```legs_valid?```
```valid?```

  ```ruby
    valid_object = MyClass.new(
      name: :name,
      surname: 'surname',
      age: 20,
      legs: 2
    )
    valid_object.valid?
  ```

  returns

  ```
  true
  ```

  ```ruby
    invalid_object = MyClass.new(
      name: 'name',
      surname: 'surname',
      age: 20,
      legs: 2
    )
    invalid_object.valid?
  ```

  returns

  ```
  false
  ```

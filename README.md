Sinclair
========
[![Code Climate](https://codeclimate.com/github/darthjee/sinclair/badges/gpa.svg)](https://codeclimate.com/github/darthjee/sinclair)
[![Test Coverage](https://codeclimate.com/github/darthjee/sinclair/badges/coverage.svg)](https://codeclimate.com/github/darthjee/sinclair/coverage)
[![Issue Count](https://codeclimate.com/github/darthjee/sinclair/badges/issue_count.svg)](https://codeclimate.com/github/darthjee/sinclair)
[![Gem Version](https://badge.fury.io/rb/sinclair.svg)](https://badge.fury.io/rb/sinclair)


![sinclair](https://raw.githubusercontent.com/darthjee/sinclair/master/sinclair.jpg)

This gem helps the creation of complex gems/concerns
that enables creation of methods on the fly through class
methods

Yard Documentation
-------------------
https://www.rubydoc.info/gems/sinclair/1.4.1

Installation
---------------
  - Install it

```ruby
  gem install sinclair
```

  - Or add Sinclair to your `Gemfile` and `bundle install`:

```ruby
  gem 'sinclair'
```

```bash
  bundle install sinclair
```

Usage
---------------
# Sinclair
Sinclair can actully be used in several ways, as an stand alone object capable of
adding methods to your class on the fly, as a builder inside a class method
or by extending it for more complex logics

## Stand Alone usage creating methods on the fly:

```ruby

  class Clazz
  end

  builder = Sinclair.new(Clazz)

  builder.add_method(:twenty, '10 + 10')
  builder.add_method(:eighty) { 4 * twenty }
  builder.build

  instance = Clazz.new

  puts "Twenty => #{instance.twenty}" # Twenty => 20
  puts "Eighty => #{instance.eighty}" # Eighty => 80
```

## Builder in class method:

```ruby
  class HttpJsonModel
    attr_reader :json

    class << self
      def parse(attribute, path: [])
        builder = Sinclair.new(self)

        keys = (path + [attribute]).map(&:to_s)

        builder.add_method(attribute) do
          keys.inject(hash) { |h, key| h[key] }
        end

        builder.build
      end
    end

    def initialize(json)
      @json = json
    end

    def hash
      @hash ||= JSON.parse(json)
    end
  end

  class HttpPerson < HttpJsonModel
    parse :uid
    parse :name,     path: [:personal_information]
    parse :age,      path: [:personal_information]
    parse :username, path: [:digital_information]
    parse :email,    path: [:digital_information]
  end

  json = <<-JSON
    {
      "uid": "12sof511",
      "personal_information":{
        "name":"Bob",
        "age": 21
      },
      "digital_information":{
        "username":"lordbob",
        "email":"lord@bob.com"
      }
    }
  JSON

  person = HttpPerson.new(json)

  person.uid      # returns '12sof511'
  person.name     # returns 'Bob'
  person.age      # returns 21
  person.username # returns 'lordbob'
  person.email    # returns 'lord@bob.com'
```

## Extending the builder

```ruby

  class ValidationBuilder < Sinclair
     delegate :expected, to: :options_object

     def initialize(klass, options={})
       super
     end

     def add_validation(field)
      add_method("#{field}_valid?", "#{field}.is_a?#{expected}")
    end

    def add_accessors(fields)
      klass.send(:attr_accessor, *fields)
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
  ```valid?```.

```ruby
  valid_object = MyClass.new(
    name: :name,
    surname: 'surname',
    age: 20,
    legs: 2
  )
  valid_object.valid? # returns true
```

```ruby

  invalid_object = MyClass.new(
    name: 'name',
    surname: 'surname',
    age: 20,
    legs: 2
  )
  invalid_object.valid? # returns false
```

## Caching the result
If wanted, the result of the method can be stored in an
instance variable with the same name.

When caching, you can cache with type `:full` so that even `nil`
values are cached

```ruby
  class MyModel
    attr_accessor :base, :expoent
  end

  builder = Sinclair.new(MyModel)

  builder.add_method(:cached_power, cached: true) do
    base ** expoent
  end

  # equivalent of builder.add_method(:cached_power) do
  #   @cached_power ||= base ** expoent
  # end

  builder.build

  model.base    = 3
  model.expoent = 2

  model.cached_power # returns 9
  model.expoent = 3
  model.cached_power # returns 9 (from cache)
```

```ruby
  module DefaultValueable
    def default_reader(*methods, value:, accept_nil: false)
      DefaultValueBuilder.new(
        self, value: value, accept_nil: accept_nil
      ).add_default_values(*methods)
    end
  end

  class DefaultValueBuilder < Sinclair
    def add_default_values(*methods)
      default_value = value

      methods.each do |method|
        add_method(method, cached: cache_type) { default_value }
      end

      build
    end

    private

    delegate :accept_nil, :value, to: :options_object

    def cache_type
      accept_nil ? :full : :simple
    end
  end

  class Server
    extend DefaultValueable

    attr_writer :host, :port

    default_reader :host, value: 'server.com', accept_nil: false
    default_reader :port, value: 80,           accept_nil: true

    def url
      return "http://#{host}" unless port

      "http://#{host}:#{port}"
    end
  end

  server = Server.new

  server.url # returns 'http://server.com:80'

  server.host = 'interstella.com'
  server.port = 5555
  server.url # returns 'http://interstella.com:5555'

  server.host = nil
  server.port = nil
  server.url # return 'http://server.com'
```

# Sinclair::Configurable

Configurable is a module that, when used, can add configurations
to your classes/modules.

Configurations are read-only objects that can only be set using
the `configurable#configure` method which accepts a block or
hash

```ruby
  module MyConfigurable
    extend Sinclair::Configurable

    # port is defaulted to 80
    configurable_with :host, port: 80
  end

  MyConfigurable.configure(port: 5555) do |config|
    config.host 'interstella.art'
  end

  MyConfigurable.config.host # returns 'interstella.art'
  MyConfigurable.config.port # returns 5555

  MyConfigurable.reset_config

  MyConfigurable.config.host # returns nil
  MyConfigurable.config.port # returns 80
```

Configurations can also be done through custom classes

```ruby
  class MyServerConfig < Sinclair::Config
    config_attributes :host, :port

    def url
      if @port
        "http://#{@host}:#{@port}"
      else
        "http://#{@host}"
      end
    end
  end

  class Client
    extend Sinclair::Configurable

    configurable_by MyServerConfig
  end

  Client.configure do
    host 'interstella.com'
  end

  Client.config.url # returns 'http://interstella.com'

  Client.configure do |config|
    config.port 8080
  end

  Client.config.url # returns 'http://interstella.com:8080'
```

RSspec matcher
---------------

You can use the provided matcher to check that your builder is adding a method correctly

```ruby

  class DefaultValue
    delegate :build, to: :builder
    attr_reader :klass, :method, :value

    def initialize(klass, method, value)
      @klass = klass
      @method = method
      @value = value
    end

    private

    def builder
      @builder ||= Sinclair.new(klass).tap do |b|
        b.add_method(method) { value }
      end
    end
  end

  require 'sinclair/matchers'
  RSpec.configure do |config|
    config.include Sinclair::Matchers
  end

  RSpec.describe DefaultValue do
    let(:klass)    { Class.new }
    let(:method)   { :the_method }
    let(:value)    { Random.rand(100) }
    let(:builder)  { described_class.new(klass, method, value) }
    let(:instance) { klass.new }

    context 'when the builder runs' do
      it do
        expect do
          described_class.new(klass, method, value).build
        end.to add_method(method).to(instance)
      end
    end

    context 'when the builder runs' do
      it do
        expect do
          described_class.new(klass, method, value).build
        end.to add_method(method).to(klass)
      end
    end
  end
```

```bash

> bundle exec rspec
```

```string

DefaultValue
  when the builder runs
      should add method 'the_method' to #<Class:0x0000000146c160> instances
  when the builder runs
      should add method 'the_method' to #<Class:0x0000000143a1b0> instances

```

Projects Using
---------------

- [Arstotzka](https://github.com/darthjee/arstotzka)


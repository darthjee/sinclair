Sinclair
========
[![Code Climate](https://codeclimate.com/github/darthjee/sinclair/badges/gpa.svg)](https://codeclimate.com/github/darthjee/sinclair)
[![Test Coverage](https://codeclimate.com/github/darthjee/sinclair/badges/coverage.svg)](https://codeclimate.com/github/darthjee/sinclair/coverage)
[![Issue Count](https://codeclimate.com/github/darthjee/sinclair/badges/issue_count.svg)](https://codeclimate.com/github/darthjee/sinclair)
[![Gem Version](https://badge.fury.io/rb/sinclair.svg)](https://badge.fury.io/rb/sinclair)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/9836de08612e46b889c7978be2b72a14)](https://www.codacy.com/manual/darthjee/sinclair?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=darthjee/sinclair&amp;utm_campaign=Badge_Grade)
[![Inline docs](http://inch-ci.org/github/darthjee/sinclair.svg?branch=master)](http://inch-ci.org/github/darthjee/sinclair)

![sinclair](https://raw.githubusercontent.com/darthjee/sinclair/master/sinclair.jpg)

Sinclair is a Ruby gem that provides developers with a variety of utility modules and classes
to simplify common tasks, reusability and avoid boilerplate code. Whether you need to class methods to create methods on the fly,
create custom comparators, configure your application, create powerfull options, Sinclair has got you covered.

Employing Sinclair in your applications helps you streamline your development workflow and enhance your development process through more efficient, cleaner code

Current Release: [3.0.0](https://github.com/darthjee/sinclair/tree/3.0.0)

[Next release](https://github.com/darthjee/sinclair/compare/3.0.0...master)

Yard Documentation
-------------------
[https://www.rubydoc.info/gems/sinclair/3.0.0](https://www.rubydoc.info/gems/sinclair/3.0.0)

Installation
---------------

  -  Install it

```ruby
  gem install sinclair
```

  -  Or add Sinclair to your `Gemfile` and `bundle install`:

```ruby
  gem 'sinclair'
```

```bash
  bundle install sinclair
```

Usage
---------------
### Sinclair builder
Sinclair can actually be used in several ways
  - as a stand alone object capable of adding methods to your class on the fly
  - as a builder inside a class method
  - extending the builder for more complex logics

<details>
<summary>Stand Alone usage creating methods on the fly</summary>

```ruby
class Clazz
end

builder = Sinclair.new(Clazz)

builder.add_method(:twenty, '10 + 10')
builder.add_method(:eighty) { 4 * twenty }
builder.add_class_method(:one_hundred) { 100 }
builder.add_class_method(:one_hundred_twenty, 'one_hundred + 20')
builder.build

instance = Clazz.new

puts "Twenty => #{instance.twenty}" # Twenty => 20
puts "Eighty => #{instance.eighty}" # Eighty => 80

puts "One Hundred => #{Clazz.one_hundred}"        # One Hundred => 100
puts "One Hundred => #{Clazz.one_hundred_twenty}" # One Hundred Twenty => 120
```
</details>

<details>
<summary>Builder in class method</summary>

```ruby
# http_json_model.rb

class HttpJsonModel
  attr_reader :json

  class << self
    def parse(attribute, path: [])
      keys = (path + [attribute]).map(&:to_s)

      Sinclair.build(self) do
        add_method(attribute) do
          keys.inject(hash) { |h, key| h[key] }
        end
      end
    end
  end

  def initialize(json)
    @json = json
  end

  def hash
    @hash ||= JSON.parse(json)
  end
end
```

```ruby
# http_person.rb

class HttpPerson < HttpJsonModel
  parse :uid
  parse :name,     path: [:personal_information]
  parse :age,      path: [:personal_information]
  parse :username, path: [:digital_information]
  parse :email,    path: [:digital_information]
end
```

```ruby
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
</details>

<details>
<summary>Class method adding class methods</summary>

```ruby
module EnvSettings
  def env_prefix(new_prefix=nil)
    @env_prefix = new_prefix if new_prefix
    @env_prefix
  end

  def from_env(*method_names)
    builder = Sinclair.new(self)

    method_names.each do |method_name|
      env_key = [env_prefix, method_name].compact.join('_').upcase

      builder.add_class_method(method_name, cached: true) do
        ENV[env_key]
      end

      builder.build
    end
  end
end

class MyServerConfig
  extend EnvSettings

  env_prefix :server

  from_env :host, :port
end

ENV['SERVER_HOST'] = 'myserver.com'
ENV['SERVER_PORT'] = '9090'

MyServerConfig.host # returns 'myserver.com'
MyServerConfig.port # returns '9090'
```
</details>

<details>
<summary>Extending the builder</summary>

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
</details>

#### Different ways of adding the methods
There are different ways to add a method, each accepting different options

<details>
<summary>Define method using block</summary>

Block methods accepts, as option
  -  [cache](#caching-the-result): defining the cashing of results

```ruby
klass = Class.new
instance = klass.new

Sinclair.build(klass) do
  add_method(:random_number) { Random.rand(10..20) }
end

instance.random_number # returns a number between 10 and 20
```
</details>

<details>
<summary>Define method using string</summary>

String methods accepts, as option
  -  [cache](#caching-the-result): defining the cashing of results
  -  parameters: defining accepted parameters
  -  named_parameters: defining accepted named parameters

```ruby
# Example without parameters

class MyClass
end
instance = MyClass.new

builder = Sinclair.new(MyClass)
builder.add_method(:random_number, "Random.rand(10..20)")
builder.build

instance.random_number # returns a number between 10 and 20
```

```ruby
# Example with parameters

class MyClass
end

Sinclair.build(MyClass) do
  add_class_method(
    :function, 'a ** b + c', parameters: [:a], named_parameters: [:b, { c: 15 }]
  )
end

MyClass.function(10, b: 2) # returns 115
```
</details>

<details>
<summary>Define method using a call to the class</summary>

Call method definitions right now have no options available

```ruby
class MyClass
end

builder = Sinclair.new(MyClass)
builder.add_class_method(:attr_accessor, :number, type: :call)
builder.build

MyClass.number # returns nil
MyClass.number = 10
MyClass.number # returns 10
```
</details>

#### Caching the result
If wanted, the result of the method can be stored in an
instance variable with the same name.

When caching, you can cache with type `:full` so that even `nil`
values are cached

<details>
<summary>Example of simple cache usage</summary>

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
</details>

<details>
<summary>Usage of different cache types</summary>

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
</details>

### Sinclair::Configurable

Configurable is a module that, when used, can add configurations
to your classes/modules.

Configurations are read-only objects that can only be set using
the `configurable#configure` method which accepts a block or
hash

<details>
<summary>Using configurable</summary>

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

# Configurable enables options that can be passed
MyConfigurable.as_options.host # returns 'interstella.art'

# Configurable enables options that can be passed with custom values
MyConfigurable.as_options(host: 'other').host # returns 'other'

MyConfigurable.reset_config

MyConfigurable.config.host # returns nil
MyConfigurable.config.port # returns 80
```
</details>

Configurations can also be done through custom classes

<details>
<summary>Using configration class</summary>

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
</details>

### Sinclair::EnvSettable

EnvSettable is a convenient utility that allows you to read environment
variables using Ruby class methods.

With this tool, you can define the usage of environment variables for your application in a single location
allowing the use of prefixes to isolate groups of variables.

This not only makes your code more readable and maintainable but also adds layer of security by ensuring
that sensitive information like API keys and passwords are not exposed in your source code.

EnvSettable allows accessing those variables thorugh a simple meta-programable way

<details>
<summary>Using env settable example</summary>

```ruby
class ServiceClient
  extend Sinclair::EnvSettable
  attr_reader :username, :password, :host, :port

  settings_prefix 'SERVICE'

  with_settings :username, :password, port: 80, hostname: 'my-host.com'

  def self.default
    @default ||= new
  end

  def initialize(
    username: self.class.username,
    password: self.class.password,
    port: self.class.port,
    hostname: self.class.hostname
  )
    @username = username
    @password = password
    @port = port
    @hostname = hostname
  end
end

ENV['SERVICE_USERNAME'] = 'my-login'
ENV['SERVICE_HOSTNAME'] = 'host.com'

ServiceClient.default # returns #<ServiceClient:0x0000556fa1b366e8 @username="my-login", @password=nil, @port=80, @hostname="host.com">'
```
</details>

### Sinclair::Options
Options allows projects to have an easy to configure option object

<details>
<summary>Example of using Options</summary>

```ruby
class ConnectionOptions < Sinclair::Options
  with_options :timeout, :retries, port: 443, protocol: 'https'

  # skip_validation if you dont want to validate intialization arguments
end

options = ConnectionOptions.new(
  timeout: 10,
  protocol: 'http'
)

options.timeout  # returns 10
options.retries  # returns nil
options.protocol # returns 'http'
options.port     # returns 443

ConnectionOptions.new(invalid: 10) # raises Sinclair::Exception::InvalidOptions
```
</details>

### Sinclair::Comparable
Comparable allows a class to implement quickly a `==` method comparing given attributes

<details>
<summary>Example of Comparable usage</summary>

```ruby
class SampleModel
  include Sinclair::Comparable

  comparable_by :name
  attr_reader :name, :age

  def initialize(name: nil, age: nil)
    @name = name
    @age  = age
  end
end

model1 = model_class.new(name: 'jack', age: 21)
model2 = model_class.new(name: 'jack', age: 23)

model1 == model2 # returns true
```
</details>

### Sinclair::Model
Model class for quickly creation of plain simple classes/models

When creating a model class, options can be passed
-  writter: Adds writter/setter methods (defaults to true)
-  comparable: Adds the fields when running a `==` method (defaults to true)

<details>
<summary>Example of simple usage</summary>

```ruby
class Human < Sinclair::Model
  initialize_with :name, :age, { gender: :undefined }, **{}
end

human1 = Human.new(name: 'John Doe', age: 22)
human2 = Human.new(name: 'John Doe', age: 22)

human1.name      # returns 'John Doe'
human1.age       # returns 22
human1.gender    # returns :undefined
human1 == human2 # returns true
```
</details>

<details>
<summary>Example with options</summary>

```ruby
class Tv < Sinclair::Model
  initialize_with :model, writter: false, comparable: false
end

tv1 = Tv.new(model: 'Sans Sunga Xt')
tv2 = Tv.new(model: 'Sans Sunga Xt')

tv1 == tv2 # returns false
```
</details>

RSspec matcher
---------------

You can use the provided matcher to check that your builder is adding a method correctly

<details>
<summary>Sample of specs over adding methods</summary>

```ruby
# spec_helper.rb

RSpec.configure do |config|
  config.include Sinclair::Matchers
end
```

```ruby
# default_value.rb
class DefaultValue
  delegate :build, to: :builder
  attr_reader :klass, :method, :value, :class_method

  def initialize(klass, method, value, class_method: false)
    @klass = klass
    @method = method
    @value = value
    @class_method = class_method
  end

  private

  def builder
    @builder ||= Sinclair.new(klass).tap do |b|
      if class_method
        b.add_class_method(method) { value }
      else
        b.add_method(method) { value }
      end
    end
  end
end
```

```ruby
# default_value_spec.rb

RSpec.describe DefaultValue do
  subject(:builder_class) { DefaultValue }

  let(:klass)         { Class.new }
  let(:method)        { :the_method }
  let(:value)         { Random.rand(100) }
  let(:builder)       { builder_class.new(klass, method, value) }
  let(:instance)      { klass.new }

  context 'when the builder runs' do
    it do
      expect { builder.build }.to add_method(method).to(instance)
    end
  end

  context 'when the builder runs' do
    it do
      expect { builder.build }.to add_method(method).to(klass)
    end
  end

  context 'when adding class methods' do
    subject(:builder) { builder_class.new(klass, method, value, class_method: true) }

    context 'when the builder runs' do
      it do
        expect { builder.build }.to add_class_method(method).to(klass)
      end
    end
  end
end
```

```bash
> bundle exec rspec
```

```string
Sinclair::Matchers
  when the builder runs
    should add method 'the_method' to #<Class:0x000055e5d9b7f150> instances
      when the builder runs
        should add method 'the_method' to #<Class:0x000055e5d9b8c0a8> instances
      when adding class methods
        when the builder runs
          should add method class_method 'the_method' to #<Class:0x000055e5d9b95d88>
```
</details>

Projects Using
---------------

  - [Arstotzka](https://github.com/darthjee/arstotzka)
  - [Azeroth](https://github.com/darthjee/azeroth)
  - [Magicka](https://github.com/darthjee/magicka)

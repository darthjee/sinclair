# Sinclair – Usage Guide for Dependent Projects

This document describes how to use the **sinclair** gem in your project.
Copy this file into your project's `.github/` directory so that GitHub Copilot
is aware of the patterns and conventions Sinclair provides.

**Current release**: 3.1.0
**Docs**: <https://www.rubydoc.info/gems/sinclair/3.1.0>

---

## Installation

Add to your `Gemfile`:

```ruby
gem 'sinclair'
```

then run:

```bash
bundle install
```

---

## Features Overview

| Feature | Class / Module | Purpose |
|---|---|---|
| Method builder | `Sinclair` | Add instance/class methods dynamically |
| Configuration | `Sinclair::Configurable` + `Sinclair::Config` | Read-only config with defaults |
| Options | `Sinclair::Options` | Validated parameter objects |
| Env variables | `Sinclair::EnvSettable` | Read ENV vars via class methods |
| Equality | `Sinclair::Comparable` | Attribute-based `==` |
| Plain models | `Sinclair::Model` | Quick data-model classes |
| Type casting | `Sinclair::Caster` | Extensible type transformations |
| RSpec matchers | `Sinclair::Matchers` | Test method-builder behaviour |

---

## 1. Sinclair – Dynamic Method Builder

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

## 2. Sinclair::Configurable – Application Configuration

`Sinclair::Configurable` adds a read-only `config` object to any class or
module. Settings can only be changed through `configure`.

### Inline attributes

```ruby
module MyApp
  extend Sinclair::Configurable

  configurable_with :host, port: 80, debug: false
end

MyApp.configure(port: 5555) do |config|
  config.host 'example.com'
end

MyApp.config.host  # => 'example.com'
MyApp.config.port  # => 5555

MyApp.reset_config
MyApp.config.host  # => nil
MyApp.config.port  # => 80

# Convert to Options object (useful for passing around)
MyApp.as_options(host: 'other').host  # => 'other'
```

### Custom config class

```ruby
class ServerConfig < Sinclair::Config
  config_attributes :host, :port

  def url
    @port ? "http://#{@host}:#{@port}" : "http://#{@host}"
  end
end

class Client
  extend Sinclair::Configurable
  configurable_by ServerConfig
end

Client.configure { host 'api.example.com' }
Client.config.url  # => 'http://api.example.com'

Client.configure { port 8080 }
Client.config.url  # => 'http://api.example.com:8080'
```

---

## 3. Sinclair::Options – Validated Option Objects

`Sinclair::Options` creates structured option/parameter value objects with
defaults and validation against unknown keys.

```ruby
class ConnectionOptions < Sinclair::Options
  with_options :timeout, :retries, port: 443, protocol: 'https'
end

opts = ConnectionOptions.new(timeout: 30, protocol: 'http')
opts.timeout   # => 30
opts.retries   # => nil
opts.port      # => 443  (default)
opts.protocol  # => 'http'
opts.to_h      # => { timeout: 30, retries: nil, port: 443, protocol: 'http' }

ConnectionOptions.new(unknown_key: 1)
# raises Sinclair::Exception::InvalidOptions
```

Call `skip_validation` in the class body to allow unknown keys:

```ruby
class LooseOptions < Sinclair::Options
  with_options :name
  skip_validation
end
```

---

## 4. Sinclair::EnvSettable – Environment Variable Access

`EnvSettable` exposes environment variables as class-level methods, with
optional prefix and default values.

```ruby
class ServiceClient
  extend Sinclair::EnvSettable

  settings_prefix 'SERVICE'
  with_settings :username, :password, port: 80, hostname: 'my-host.com'
end

ENV['SERVICE_USERNAME'] = 'my-login'
ENV['SERVICE_HOSTNAME'] = 'host.com'

ServiceClient.username  # => 'my-login'
ServiceClient.hostname  # => 'host.com'
ServiceClient.port      # => 80   (default – ENV var not set)
ServiceClient.password  # => nil  (ENV var not set, no default)
```

### Type casting

```ruby
class AppConfig
  extend Sinclair::EnvSettable

  settings_prefix 'APP'
  setting_with_options :timeout, type: :integer, default: 30
  setting_with_options :debug,   type: :boolean
  setting_with_options :rate,    type: :float
end

ENV['APP_TIMEOUT'] = '60'
AppConfig.timeout  # => 60  (Integer)
```

---

## 5. Sinclair::Comparable – Attribute-based Equality

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

## 6. Sinclair::Model – Quick Plain-Ruby Models

`Sinclair::Model` generates reader/writer methods, a keyword-argument
initializer, and equality (via `Sinclair::Comparable`) in one call.

There are two ways to define a model:

- **`initialize_with`** – called inside the class body; adds methods to the current class.
- **`.for`** – class method that returns a new anonymous subclass; useful when inheriting inline.

### Basic model (initialize_with)

```ruby
class Human < Sinclair::Model
  initialize_with :name, :age, { gender: :undefined }, **{}
end

h1 = Human.new(name: 'John', age: 22)
h2 = Human.new(name: 'John', age: 22)

h1.name      # => 'John'
h1.gender    # => :undefined
h1 == h2     # => true

h1.name = 'Jane'  # setter generated by default
```

### Disabling writers or equality (initialize_with)

```ruby
class Tv < Sinclair::Model
  initialize_with :brand, :model, writter: false, comparable: false
end

tv1 = Tv.new(brand: 'Sony', model: 'X90L')
tv2 = Tv.new(brand: 'Sony', model: 'X90L')

tv1 == tv2  # => false  (comparable disabled)
```

### Using .for (inline subclassing)

```ruby
class Car < Sinclair::Model.for(:brand, :model, writter: false)
end

car = Car.new(brand: :ford, model: :T)

car.brand  # => :ford
car.model  # => :T
```

### Using .for with default values

```ruby
class Job < Sinclair::Model.for({ state: :starting }, writter: true)
end

job = Job.new

job.state       # => :starting
job.state = :done
job.state       # => :done
```

Options accepted by both `initialize_with` and `.for`:

| Option | Default | Description |
|---|---|---|
| `writter:` | `true` | Generate setter methods |
| `comparable:` | `true` | Include field in `==` comparison |

---

## 7. Sinclair::Caster – Type Casting

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

## 8. Sinclair::Matchers – RSpec Matchers

Include `Sinclair::Matchers` in your RSpec configuration to gain matchers for
testing that a builder adds or changes methods.

### Setup

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  config.include Sinclair::Matchers
end
```

### Available matchers

```ruby
# Checks that build adds an instance method
expect { builder.build }.to add_method(:name).to(instance)
expect { builder.build }.to add_method(:name).to(klass)

# Checks that build adds a class method
expect { builder.build }.to add_class_method(:count).to(klass)

# Checks that build changes an existing instance method
expect { builder.build }.to change_method(:value).on(instance)

# Checks that build changes an existing class method
expect { builder.build }.to change_class_method(:count).on(klass)
```

### Example spec

```ruby
RSpec.describe MyBuilder do
  let(:klass)    { Class.new }
  let(:instance) { klass.new }
  let(:builder)  { MyBuilder.new(klass) }

  it 'adds a greeting method to instances' do
    expect { builder.build }.to add_method(:greet).to(instance)
  end

  it 'adds a factory class method' do
    expect { builder.build }.to add_class_method(:create).to(klass)
  end
end
```

---

## Complete Example

```ruby
# Combining multiple Sinclair features in one class

class ApiClient
  extend Sinclair::Configurable
  extend Sinclair::EnvSettable
  include Sinclair::Comparable

  # --- Configuration (set programmatically) ---
  configurable_with :timeout, retries: 3

  # --- Environment variables ---
  settings_prefix 'API'
  with_settings :api_key, :secret, base_url: 'https://api.example.com'

  # --- Equality based on base_url ---
  comparable_by :base_url

  attr_reader :base_url

  def initialize(base_url: self.class.base_url)
    @base_url = base_url
  end
end

# Wire up at boot time
ENV['API_API_KEY'] = 'secret-key'
ApiClient.configure(timeout: 60)

client1 = ApiClient.new
client2 = ApiClient.new

client1 == client2          # => true
ApiClient.config.timeout    # => 60
ApiClient.config.retries    # => 3
ApiClient.api_key           # => 'secret-key'
```

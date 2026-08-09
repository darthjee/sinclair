# Sinclair::Matchers – RSpec Matchers

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

[Back to index](../sinclair-usage.md)

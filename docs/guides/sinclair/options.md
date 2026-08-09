# Sinclair::Options – Validated Option Objects

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

[Back to index](../sinclair-usage.md)

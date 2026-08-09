# Sinclair::Configurable – Application Configuration

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

[Back to index](../sinclair-usage.md)

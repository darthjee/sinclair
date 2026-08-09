# Sinclair::EnvSettable – Environment Variable Access

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

[Back to index](../sinclair-usage.md)

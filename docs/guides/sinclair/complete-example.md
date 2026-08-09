# Complete Example

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

---

[Back to index](../sinclair-usage.md)

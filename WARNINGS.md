# Warnings
This documents tries to bring more information on warnings
and depreations on current versions of the gem.

## Usage of custom config classes
Introduced: 1.3.0
Changed in: 1.4.0

In the past, you could use any custom configuration classes
to configure your configurable

```ruby
class MyConfig
  def url
    if @port
      "http://#{@host}:#{@port}"
    else
      "http://#{@host}"
    end
  end
end

class MyClient
  configutable_by MyConfig, with: [:host, :port]
  configurable_with timeout: 5.seconds
end
```

Now, the configuration class should extend ```Sinclair::ConfigClass```
and the attributes defined within the class itself

```ruby
class MyConfig
  extend Sinclair::ConfigClass

  add_attributes :host, :port

  def url
    if @port
      "http://#{@host}:#{@port}"
    else
      "http://#{@host}"
    end
  end
end

class MyClient
  configutable_by MyConfig

  configurable_with timeout: 5.seconds
end
```

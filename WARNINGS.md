# Warnings
This documents tries to bring more information on warnings
and depreations on current versions of the gem.

## Usage of custom config classes
Introduced: 1.3.0
Changed in: 1.4.0

In the past, you could use any custom configuration classes
to configure your configurable. Those classes could be
extended through the regular usage of ```.configurable_with```
or have it's configuration attributes declared by
```with``` option on ```configurable_with```

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

MyClient.configure do
  port 5555
  host 'myhost.com'
  timeout 10.seconds
end
```

Now, the configuration class should extend ```Sinclair::ConfigClass```
and the attributes defined within the class itself, still
being able to extend it through the usage of
```.configurable_with``` call after ```configurable_by```

```ruby
class MyConfig
  extend Sinclair::ConfigClass

  config_attributes :host, :port

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

MyClient.configure do
  port 5555
  host 'myhost.com'
  timeout 10.seconds
end
```

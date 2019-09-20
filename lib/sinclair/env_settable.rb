# frozen_string_literal: true

class Sinclair
  module EnvSettable
    autoload :Builder, 'sinclair/env_settable/builder'

    def settings_prefix(prefix)
      @settings_prefix = prefix
    end

    def with_settings(*settings_name, **defaults)
      Builder.new(self, @settings_prefix, *settings_name, **defaults).build
    end
  end
end

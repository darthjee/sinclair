# frozen_string_literal: true

module EnvSettings
  def env_prefix(new_prefix = nil)
    @env_prefix = new_prefix if new_prefix
    @env_prefix
  end

  def from_env(*method_names)
    builder = Sinclair.new(self)

    method_names.each do |method_name|
      env_key = [env_prefix, method_name].compact.join('_').upcase

      builder.add_class_method(method_name, cached: true) do
        ENV.fetch(env_key, nil)
      end

      builder.build
    end
  end
end

# frozen_string_literal: true

module YamlFileSettable
  include Sinclair::Settable
  extend Sinclair::Settable::ClassMethods

  read_with do |key|
    loaded_yaml[key.to_s]
  end

  def loaded_yaml
    YAML.load_file(setting_file)
  end

  def setting_file(file_path = @setting_file)
    @setting_file = file_path
  end
end

class YamlFileSettings
  extend YamlFileSettable

  setting_file './spec/support/files/config.yml'

  setting_with_options :timeout, default: 30
end

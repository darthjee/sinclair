# frozen_string_literal: true

class Sinclair
  module Settable
    # @api public
    # @author darthjee
    #
    # Class methods availabe inside a Settable module
    #
    # The methods should help configuring the settable
    #
    # @see #read_with
    module ClassMethods
      # Register and return a block for reading a setting
      #
      # @param read_block [Proc] the block that will be used when
      #   reading a setting key
      #
      # When the block is called, it will receive the key and any
      # given options
      #
      # @example
      #   # config.yml
      #   # timeout: 10
      #
      #   # yaml_file_settable.rb
      #
      #   module YamlFileSettable
      #     include Sinclair::Settable
      #     extend Sinclair::Settable::ClassMethods
      #
      #     read_with do |key, default: nil|
      #       loaded_yaml[key.to_s] || default
      #     end
      #
      #     def loaded_yaml
      #       YAML.load_file(setting_file)
      #     end
      #
      #     def setting_file(file_path = @setting_file)
      #       @setting_file = file_path
      #     end
      #   end
      #
      #   # yaml_file_settings.rb
      #
      #   class YamlFileSettings
      #     extend YamlFileSettable
      #
      #     setting_file 'config.yml'
      #
      #     setting_with_options :timeout, default: 30
      #   end
      #
      #   YamlFileSettings.timeout # returns 10
      def read_with(&read_block)
        return @read_block = read_block if read_block
        return @read_block if @read_block

        superclass_settable&.read_with
      end

      private

      # @private
      #
      # Returns a {Settable} module representing a superclass
      #
      # @return [Module]
      def superclass_settable
        included_modules.find do |modu|
          modu <= Sinclair::Settable
        end
      end
    end
  end
end

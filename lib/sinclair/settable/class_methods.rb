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
      def read_with(&read_block)
        return @read_block = read_block if read_block
        return @read_block if @read_block

        superclass_settable&.read_with
      end

      private

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

# frozen_string_literal: true

class Sinclair
  # @api public
  # @author darthjee
  #
  # Settable that recovers data from other settables
  #
  # Each setting obeys a settable order and when a setting value is not found,
  # the next is checked
  module ChainSettable
    include Sinclair::Settable
    extend Sinclair::Settable::ClassMethods

    read_with do |key, sources: nil|
      sources.map_and_find do |source|
        sources_map[source].public_send(key)
      end
    end

    private

    # @private
    # @api public
    # @visibility public
    #
    # Register a setting source
    #
    # @param key [Symbol] key identifying the setting
    # @param source [Class<Settable>] Setting source class
    #
    # @return [Class<Settable>]
    def source(key, source)
      sources_map[key] = source
    end

    # @private
    # @api public
    # @visibility public
    #
    # Defines the order of the settings
    #
    # @param sources [Array<Symbol>] lis of sources in order
    #
    # @return [Array<Symbol>]
    def sources(*sources)
      @sources = sources
    end

    # @private
    # @api private
    #
    # Hash with all Setting classes defined
    #
    # @return [Hash<Symbol,Settable>]
    def sources_map
      @sources_map ||= {}
    end

    # @private
    # @api private
    #
    # Order of sources to be checked by default
    #
    # @return [Hash<Symbol,Settable>]
    def sources_order
      @sources || sources_map.keys
    end

    # @private
    # @api private
    #
    # Returns default options passed to {read_block}
    #
    # @return [Hash<Symbol,Object>]
    def default_options
      {
        sources: sources_order,
        sources_map:
      }
    end
  end
end

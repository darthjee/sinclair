# frozen_string_literal: true

class Sinclair
  module ChainSettable
    include Sinclair::Settable
    extend Sinclair::Settable::ClassMethods

    read_with do |key, default: nil, sources: nil|
      sources.map_and_find do |source|
        source.public_send(key)
      end || default
    end

    private

    # @private
    # @api public
    # @visibility public
    def source(key, settable)
      sources_map[key] = settable
    end

    # @private
    # @api public
    # @visibility public
    def sources(*sources)
      @sources = sources
    end

    # @private
    # @api private
    def sources_map
      @sources_map ||= {}
    end

    def sources_order
      @sources || sources_map.keys 
    end

    def ordered_sources
      sources_order.map do |key|
        sources_map[key]
      end
    end

    def default_options
      {
        sources: ordered_sources
      }
    end
  end
end

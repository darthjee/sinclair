# frozen_string_literal: true

class Sinclair
  module ChainSettable
    include Sinclair::Settable
    extend Sinclair::Settable::ClassMethods

    read_with do |key, default: nil, sources: nil|
      sources.each do |source|
        value = source.public_send(key)
        return value if value
      end
      default
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
    def source_order(*order)
      @source_order = order if order
      @source_order || sources_map.keys
    end

    # @private
    # @api private
    def sources_map
      @sources_map ||= {}
    end

    def ordered_sources
      source_order.map do |key|
        sources_map[key]
      end
    end

    def default_options
      {
        sources: source_order
      }
    end
  end
end

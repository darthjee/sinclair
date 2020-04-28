class Sinclair
  module InputHashable
    def input_hash(*args)
      defaults = args.find { |arg| arg.is_a?(Hash) } || {}
      args.delete(defaults)

      hash = Hash[args.map { |*name| name }]
      hash.merge!(defaults)
    end
  end
end

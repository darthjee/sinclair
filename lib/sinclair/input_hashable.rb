class Sinclair
  module InputHashable
    def input_hash(*names, **defaults)
      hash = Hash[names.map { |*name| name }]
      
      hash.merge!(defaults)
    end
  end
end

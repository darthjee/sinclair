# frozen_string_literal: true

class HashModel
  def initialize(hash)
    hash.each do |attribute, value|
      method_name = "#{attribute}="

      send(method_name, value) if respond_to?(method_name)
    end
  end
end

# frozen_string_literal: true

class RandomGenerator
  KAPA = 3.9 + Random.rand / 10.0

  class << self
    def rand
      @rand ||= Random.rand

      @rand = KAPA * @rand * (1 - @rand)
    end
  end
end

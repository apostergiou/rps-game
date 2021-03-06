module Games
  class RPS
    include Comparable
    attr_accessor :move, :name

    WINS = [%w[rock scissors],
            %w[scissors paper],
            %w[paper rock]].freeze

    def initialize(move, name)
      @move = move.to_s
      @name = name
    end

    def <=>(other)
      if move == other.move
        0
      elsif WINS.include?([move, other.move])
        1
      elsif WINS.include?([other.move, move])
        -1
      else
        raise ArgumentError, "Something's wrong"
      end
    end

    def play(other)
      if self > other
        self
      elsif other > self
        other
      else
        false
      end
    end
  end
end

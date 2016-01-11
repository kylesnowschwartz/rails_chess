class Board
  attr_accessor :current_positions

  WIDTH = 8

  RANK1 = (56..63)
  RANK2 = (48..55)
  RANK3 = (40..47)
  RANK4 = (32..39)
  RANK5 = (24..31)
  RANK6 = (16..23)
  RANK7 = (8..15) 
  RANK8 = (0..7)

  FILEA = (0..56).step(8)
  FILEB = (1..57).step(8)
  FILEC = (2..58).step(8)
  FILED = (3..59).step(8)
  FILEE = (4..60).step(8)
  FILEF = (5..61).step(8)
  FILEG = (6..62).step(8)
  FILEH = (7..63).step(8)

  POSITIONS = [RANK8, RANK7, RANK6, RANK5, RANK4, RANK3, RANK2, RANK1].map(&:to_a)

  def initialize
    @current_positions = []
  end

  def inspect
    PresentBoard.new.call(self)
  end

  def piece(position)
    current_positions[position]
  end

  def position(piece)
    current_positions.find_index(piece)
  end
end
class Board
  attr_accessor :current_positions

  WIDTH = 8
  RANKS = (0..63).to_a.in_groups_of(WIDTH).reverse
  FILES = RANKS.reverse.transpose

  RANKS.each_with_index do |rank, index|
    Board.const_set("RANK#{index + 1}", rank)
  end

  FILES.each_with_index do |file, index|
    letters = ("A".."H").to_a

    Board.const_set("FILE#{letters[index]}", file)
  end

  def initialize
    @current_positions = []
  end

  def inspect
    PresentBoard.new.call(self)
  end

  def pieces
    current_positions.compact
  end

  def piece(position)
    current_positions[position]
  end

  def position(piece)
    current_positions.find_index(piece)
  end

  def dup
    duplicated_board = Board.new 
    duplicated_board.current_positions = current_positions.map(&:dup)
    duplicated_board
  end
end
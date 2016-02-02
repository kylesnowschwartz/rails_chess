class Piece
  attr_accessor :has_moved
  attr_reader :color

  def initialize(color = Color.new)
    @color = color
    @has_moved = false
  end

  def white?
    color.white?
  end

  def black?
    color.black?
  end

  def same_color?(other)
    color == other.color
  end

  def opposite_color?(other)
    color.opposite_color == other.color
  end

  def nil_piece?
    self.is_a?(NilPiece)
  end

  def on_file_a?(position)
    Board::FILEA.include?(position)
  end

  def on_file_h?(position)
    Board::FILEH.include?(position)
  end

  def on_rank_1?(position)
    Board::RANK1.include?(position)
  end

  def on_rank_8?(position)
    Board::RANK8.include?(position)
  end
end
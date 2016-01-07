class Piece
  attr_reader :color

  def initialize(color)
    @color = color
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

  def white?
    color == 'white'
  end

  def black?
    color == 'black'
  end

  def same_color?(other)
    return false if nil_piece?
    color == other.color
  end

  def opposite_color?(other)
    return false if nil_piece?
    white? ? other.black? : other.white?
  end

  def nil_piece?
    self.is_a?(NilPiece)
  end
end
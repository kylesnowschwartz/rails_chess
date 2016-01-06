class Piece
  attr_reader :color

  def initialize(color)
    @color = color
    raise "This piece exhibits racial diversity. Kill it, and choose Black or White as God intended." unless @color == "white" || @color == "black" || @color == "nil"
  end

  def within_board?(position)
    coordinate = Square.position_to_coordinate(position)

    coordinate.row < Board::WIDTH && coordinate.column < Board::WIDTH
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
    @color == 'white'
  end

  def black?
    @color == 'black'
  end

  def same_color?(other)
    @color == other.color
  end

  def moves_within_board(moves)
    moves.select { |position| within_board?(position) }
  end

  def nil_piece?
    self.is_a?(NilPiece)
  end
end
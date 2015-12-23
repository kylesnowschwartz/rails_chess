class Piece
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def within_board?(position)
    coordinate = Board.position_to_coordinate(position)

    coordinate.row < Board::WIDTH && coordinate.column < Board::WIDTH
  end

  def on_file_a?(position)
    coordinate = Board.position_to_coordinate(position)

    coordinate.column == 0
  end

  def on_file_h?(position)
    coordinate = Board.position_to_coordinate(position)

    coordinate.column == 7
  end

  def on_rank_1?(position)
    coordinate = Board.position_to_coordinate(position)

    coordinate.row == 7
  end

  def on_rank_8?(position)
    coordinate = Board.position_to_coordinate(position)

    coordinate.row == 0
  end

  def white?
    @color == 'white'
  end

  def black?
    @color == 'black'
  end
end
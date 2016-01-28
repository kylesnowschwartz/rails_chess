require 'set'

class Square
  # TODO make this less bloated, break it up, do SOMETHING
  # TODO just intialize with a position goddamnit
  Coordinate = Struct.new(:row, :column) do
    def diagonal_to?(coordinate)
      (row - coordinate.row).abs == (column - coordinate.column).abs
    end

    def diagonal_direction(coordinate)
      # in order to seperate the diagonals by direction, 
      # we can group by the signs (same or different) of a coordinate pair
      if (row - coordinate.row <=> 0) == (column - coordinate.column <=> 0)
        :nw_to_se
      else
        :ne_to_sw
      end
    end

    def to_position
      Square.coordinate_to_position(self)
    end
  end

  def self.position_to_coordinate(position)
    Coordinate.new(position_to_row(position), 
                   position_to_column(position))
  end

  def self.coordinate_to_position(coordinate)
    coordinate = Coordinate.new(coordinate[0], coordinate[1]) if coordinate.is_a?(Array)
    coordinate.row * Board::WIDTH + coordinate.column
  end

  def self.position_to_row(position)
    position / Board::WIDTH
  end

  def self.position_to_column(position)
    position % Board::WIDTH
  end

  def self.rank(position)
    Board.const_get("RANK#{Board::WIDTH - position_to_row(position)}")
  end

  def self.file(position)
    column_index_to_file = (0..7).zip('A'..'H').to_h

    Board.const_get("FILE#{column_index_to_file[position_to_column(position)]}")
  end

  # TODO direction multiplier
  def self.two_rows_ahead(position, piece)
    piece.white? ? position - 16 : position + 16
  end

  def self.one_row_ahead(position, piece)
    piece.white? ? position - 8 : position + 8
  end

  def self.one_diagonal_forward_left(position, piece)
    piece.white? ? position - 9 : position + 9
  end

  def self.one_diagonal_forward_right(position, piece)
    piece.white? ? position - 7 : position + 7
  end

  def self.knight_moves(position)
    row = position_to_coordinate(position).row
    col = position_to_coordinate(position).column
    
    [
      [row - 2, col + 1], 
      [row + 2, col + 1], 
      [row - 2, col - 1], 
      [row + 2, col - 1], 
      [row - 1, col - 2], 
      [row - 1, col + 2], 
      [row + 1, col - 2], 
      [row + 1, col + 2], 
    ].select { |c| valid_coordinate?(c) }
     .map { |c| coordinate_to_position(c) }
  end

  def self.positions_within_board(positions)    
    positions.select { |position| within_board?(position) }
  end

  def self.within_board?(position)
    row = position_to_coordinate(position).row
    col = position_to_coordinate(position).column

    row < Board::WIDTH && col < Board::WIDTH
  end

  def self.neighbors(position)
    row = position_to_coordinate(position).row
    col = position_to_coordinate(position).column
    
    [
      [row    , col - 1], 
      [row    , col + 1], 
      [row - 1, col    ], 
      [row + 1, col    ], 
      [row - 1, col - 1], 
      [row + 1, col + 1],
      [row - 1, col + 1], 
      [row + 1, col - 1] 
    ].select { |c| valid_coordinate?(c) }
     .map { |c| coordinate_to_position(c) }
  end

  def self.valid_coordinate?((row, col))
    (0...Board::WIDTH).include?(row) &&
    (0...Board::WIDTH).include?(col)
  end

  def self.position_diagonals(current_position)
    current_coordinate = position_to_coordinate(current_position)
    board_coordinates = Board::POSITIONS.flatten.map { |position| position_to_coordinate(position) }

    board_coordinates
      .select { |coordinate| coordinate.diagonal_to?(current_coordinate) }
      .group_by { |coordinate| coordinate.diagonal_direction(current_coordinate) }
      .map { |_, coordinates| Set.new(coordinates.map(&:to_position) + [current_position]).sort }
  end
end
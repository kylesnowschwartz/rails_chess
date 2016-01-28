require 'set'

class Position
  attr_reader :position_id

  def initialize(position_id = nil)
    @position_id = position_id
  end

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
      Position.new.coordinate_to_position(self)
    end
  end

  def rank
    Board.const_get("RANK#{Board::WIDTH - position_to_row}")
  end

  def file
    column_index_to_file = (0..7).zip('A'..'H').to_h

    Board.const_get("FILE#{column_index_to_file[position_to_column]}")
  end

  # TODO direction multiplier
  def two_rows_ahead(color)
    color == "white" ? position_id - 16 : position_id + 16
  end

  def one_row_ahead(color)
    color == "white" ? position_id - 8 : position_id + 8
  end

  def one_diagonal_forward_left(color)
    color == "white" ? position_id - 9 : position_id + 9
  end

  def one_diagonal_forward_right(color)
    color == "white" ? position_id - 7 : position_id + 7
  end

  def knight_moves
    row = position_to_coordinate.row
    col = position_to_coordinate.column
    
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

  def positions_within_board(positions)    
    positions.select { |position| Position.new(position).within_board? }
  end

  def within_board?
    row = position_to_coordinate.row
    col = position_to_coordinate.column

    row < Board::WIDTH && col < Board::WIDTH
  end

  def neighbors
    row = position_to_coordinate.row
    col = position_to_coordinate.column
    
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

  def position_diagonals(current_position)
    current_coordinate = Position.new(current_position).position_to_coordinate
    board_coordinates = Board::POSITIONS.flatten.map { |position| Position.new(position).position_to_coordinate }

    board_coordinates
      .select { |coordinate| coordinate.diagonal_to?(current_coordinate) }
      .group_by { |coordinate| coordinate.diagonal_direction(current_coordinate) }
      .map { |_, coordinates| Set.new(coordinates.map(&:to_position) + [current_position]).sort }
  end

  def coordinate_to_position(coordinate)
    coordinate = Coordinate.new(coordinate[0], coordinate[1]) if coordinate.is_a?(Array)
    coordinate.row * Board::WIDTH + coordinate.column
  end
  
  def position_to_coordinate
    Coordinate.new(position_to_row, 
                   position_to_column)
  end

  private

  def position_to_row
    position_id / Board::WIDTH
  end

  def position_to_column
    position_id % Board::WIDTH
  end

  def valid_coordinate?((row, col))
    (0...Board::WIDTH).include?(row) &&
    (0...Board::WIDTH).include?(col)
  end
end
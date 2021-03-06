require 'set'

class Position
  attr_reader :cell

  def initialize(cell = nil)
    @cell = cell
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

  def n_rows_ahead(n_rows, color)
    cell_offset = (n_rows * Board::WIDTH)

    color.white? ? cell - cell_offset : cell + cell_offset
  end

  def n_diagonals_forward(n_rows, color, direction)
    directional_offset = direction == :right ? -1 : 1

    cell_offset = n_rows * (Board::WIDTH + directional_offset)

    color.white? ? cell - cell_offset : cell + cell_offset
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
    board_coordinates = Board::RANKS.flatten
      .map { |position| Position.new(position).position_to_coordinate }

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

  def position_to_row
    cell / Board::WIDTH
  end

  def position_to_column
    cell % Board::WIDTH
  end

  def valid_coordinate?((row, col))
    (0...Board::WIDTH).include?(row) &&
    (0...Board::WIDTH).include?(col)
  end
end
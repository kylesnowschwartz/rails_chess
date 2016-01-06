class Square
  Coordinate = Struct.new(:row, :column)

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
    Board.const_get("RANK" + "#{((position / Board::WIDTH) - 7).abs + 1}")
  end

  def self.file(position)
    column_index_to_file = (0..7).zip('A'..'H').to_h

    Board.const_get("FILE" + column_index_to_file[position % Board::WIDTH])
  end

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

  def self.position_diagonals(position)
    diagonals
      .select { |diagonal| diagonal.include?(position) }
      .each { |diagonal| diagonal.delete(position) }
  end

  def self.knight_moves(position)
  end

  def self.pieces_in_file(position)
    
  end

  def self.diagonals
    offset_range = ((-Board::WIDTH + 1)..Board::WIDTH)

    [Board::POSITIONS, Board::POSITIONS.map(&:reverse)]
      .inject([]) do |all_diagonals, positions|
        offset_range.each do |offset|
          diagonal = []

          (Board::WIDTH).times do |row_index|
            col_index = offset + row_index
            diagonal << positions[row_index][col_index] if col_index >= 0
          end

          all_diagonals << diagonal.compact if diagonal.compact.count > 1
        end
        all_diagonals
      end
  end
end
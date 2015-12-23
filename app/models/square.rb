class Square

  # TODO a square class (or position?) has some smart concepts like 
  #      all the diagonals, all the ones ahead and behind it, etc.

  Coordinate = Struct.new(:row, :column)

  def self.position_to_coordinate(position)
    Coordinate.new(position_to_row(position), 
                   position_to_column(position))
  end

  def self.coordinate_to_position(coordinate)
    coordinate.row * Board::WIDTH + coordinate.column
  end

  def self.position_to_row(position)
    position / Board::WIDTH
  end

  def self.position_to_column(position)
    position % Board::WIDTH
  end

  def self.rank(position)
    Board.const_get("RANK" + "#{(position / Board::WIDTH) + 1}")
  end

  def self.file(position)
    column_index_to_file = (0..7).zip('A'..'H').to_h

    Board.const_get("FILE" + column_index_to_file[position % Board::WIDTH])
  end

  def self.diagonals(position)
    # Matrix[[0, 1, 2, 3, 4, 5, 6, 7], [8, 9, 10, 11, 12, 13, 14, 15], [16, 17, 18, 19, 20, 21, 22, 23], [24, 25, 26, 27, 28, 29, 30, 31], [32, 33, 34, 35, 36, 37, 38, 39], [40, 41, 42, 43, 44, 45, 46, 47], [48, 49, 50, 51, 52, 53, 54, 55], [56, 57, 58, 59, 60, 61, 62, 63]]
    # width = Board::WIDTH
    # diagonals = []
    # top_left_corner = 0
    # top_right_corner = 7
    # bottom_left_corner = 56
    # bottom_right_corner = 63
    
    # (0..7).each do |column|
    #   diagonals << (column..bottom_right_corner).step(width + 1)
    #   bottom_right_corner -=8
    # end

    # (56..63).each do |column|
    #   diagonals << (top_right_corner..column).step(width - 1)
    #   top_right_corner +=8
    # end

    # (0..56).step(8).each do |row|
    #   diagonals << (row..bottom_right_corner).step(width - 1)
    #   bottom_right_corner -= 1
    # end

    # (7..63).step(8).each do |row|
    #   diagonals << (row..bottom_left_corner).step(width - 1)
    #   bottom_left_corner += 1
    # end

    # diagonals.select{ |range| range.include?(position) }

  end

  def self.knight_moves(position)
  end
end
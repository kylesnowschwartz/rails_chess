class Queen < Piece
  def potential_moves(position)
    @position = position

    {
      left_to_right: left_to_right,
      right_to_left: right_to_left,
      rank_array: rank_array, 
      file_array: file_array
    }
  end

  def left_to_right
    Square.position_diagonals(@position)[0] || []
  end

  def right_to_left
    Square.position_diagonals(@position)[1] || []
  end

  def rank_array
    Square.rank(@position).to_a
  end
  
  def file_array
    Square.file(@position).to_a
  end
end
class Queen < Piece
  def possible_placements(position)
    @position = position

    {
      left_to_right: left_to_right,
      right_to_left: right_to_left,
      rank_array: rank_array, 
      file_array: file_array
    }
  end

  private

  def left_to_right
    Position.new.position_diagonals(@position)[0] || []
  end

  def right_to_left
    Position.new.position_diagonals(@position)[1] || []
  end

  def rank_array
    Position.new(@position).rank.to_a
  end
  
  def file_array
    Position.new(@position).file.to_a
  end
end
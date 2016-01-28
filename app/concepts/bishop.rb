class Bishop < Piece
  def possible_placements(position)
    {
      left_to_right: Position.new.position_diagonals(position)[0],
      right_to_left: Position.new.position_diagonals(position)[1]
    }
  end
end
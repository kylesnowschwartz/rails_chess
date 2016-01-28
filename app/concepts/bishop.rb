class Bishop < Piece
  def possible_placements(position)
    {
      left_to_right: Square.position_diagonals(position)[0],
      right_to_left: Square.position_diagonals(position)[1]
    }
  end
end
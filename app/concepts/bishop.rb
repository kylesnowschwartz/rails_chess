class Bishop < Piece
  def potential_moves(position)
    {
      left_to_right: Square.position_diagonals(position)[0],
      right_to_left: Square.position_diagonals(position)[1]
    }
  end
end
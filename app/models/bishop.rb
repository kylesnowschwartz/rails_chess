class Bishop < Piece
  def potential_moves(position)
    Square.position_diagonals(position)
  end
end
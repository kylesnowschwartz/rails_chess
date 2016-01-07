class Knight < Piece
  def potential_moves(position)
    Square.knight_moves(position)
  end
end
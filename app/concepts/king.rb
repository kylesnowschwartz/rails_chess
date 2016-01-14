class King < Piece
  def potential_moves(position)
    Square.neighbors(position)
  end
end
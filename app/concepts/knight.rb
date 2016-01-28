class Knight < Piece
  def possible_placements(position)
    Square.knight_moves(position)
  end
end
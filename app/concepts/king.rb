class King < Piece
  def potential_moves(position)
    {
      moves: Square.neighbors(position),
      castles: castling_moves 
    }
  end

  def castling_moves
    white? ? [58, 62] : [2, 6]
  end
end
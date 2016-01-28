class King < Piece
  WHITE_KING_SIDE_CASTLE_TO = 62
  WHITE_KING_SIDE_CASTLE_ROOK_FROM = 63
  WHITE_KING_SIDE_CASTLE_ROOK_TO = 61

  WHITE_QUEEN_SIDE_CASTLE_TO = 58
  WHITE_QUEEN_SIDE_CASTLE_ROOK_FROM = 56
  WHITE_QUEEN_SIDE_CASTLE_ROOK_TO = 59

  BLACK_KING_SIDE_CASTLE_TO = 6
  BLACK_KING_SIDE_CASTLE_ROOK_FROM = 7
  BLACK_KING_SIDE_CASTLE_ROOK_TO = 5

  BLACK_QUEEN_SIDE_CASTLE_TO = 2
  BLACK_QUEEN_SIDE_CASTLE_ROOK_FROM = 0
  BLACK_QUEEN_SIDE_CASTLE_ROOK_TO = 3

  def possible_placements(position)
    {
      moves: Square.neighbors(position),
      castles: castling_moves 
    }
  end

  def castling_moves
    white? ? [58, 62] : [2, 6]
  end
end
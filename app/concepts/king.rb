class King < Piece
  WHITE_KING_SIDE_CASTLE_TO         = 62
  WHITE_KING_SIDE_CASTLE_ROOK_TO    = 61
  WHITE_KING_SIDE_CASTLE_ROOK_FROM  = 63

  WHITE_QUEEN_SIDE_CASTLE_TO        = 58
  WHITE_QUEEN_SIDE_CASTLE_ROOK_TO   = 59
  WHITE_QUEEN_SIDE_CASTLE_ROOK_FROM = 56

  BLACK_KING_SIDE_CASTLE_TO         = 6
  BLACK_KING_SIDE_CASTLE_ROOK_TO    = 5
  BLACK_KING_SIDE_CASTLE_ROOK_FROM  = 7

  BLACK_QUEEN_SIDE_CASTLE_TO        = 2
  BLACK_QUEEN_SIDE_CASTLE_ROOK_TO   = 3
  BLACK_QUEEN_SIDE_CASTLE_ROOK_FROM = 0

  ORIGINAL_WHITE_POSITION = 60
  ORIGINAL_BLACK_POSITION = 4

  def possible_placements(position)
    {
      moves: Position.new(position).neighbors,
      castles: castling_moves 
    }
  end

  def original_position
    black? ? ORIGINAL_BLACK_POSITION : ORIGINAL_WHITE_POSITION
  end

  private

  def castling_moves
    if white? 
      [WHITE_QUEEN_SIDE_CASTLE_TO, WHITE_KING_SIDE_CASTLE_TO] 
    else 
      [BLACK_QUEEN_SIDE_CASTLE_TO, BLACK_KING_SIDE_CASTLE_TO]
    end
  end
end
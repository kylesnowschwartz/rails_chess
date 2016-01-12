
class ValidateBishopMove < ValidatePieceMove
  def legal_moves
    all_diagonal_pieces
      .reject { |piece| piece.same_color?(@bishop) }
      .map { |piece| board.position(piece) }
      .uniq
  end

  # private

  def all_diagonal_pieces
    moves         = @bishop.potential_moves(from)
    left_to_right = pieces_on_diagonal(moves[:left_to_right])
    right_to_left = pieces_on_diagonal(moves[:right_to_left])
    
    enclosed_inclusive_subset(left_to_right) + enclosed_inclusive_subset(right_to_left)
  end

  def pieces_on_diagonal(diagonal)
    board.current_positions.values_at(*diagonal)
  end
end
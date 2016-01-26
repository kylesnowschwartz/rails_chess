class ValidateQueenMove < ValidatePieceMove
  def legal_moves
    (all_diagonal_pieces + rank_and_file_pieces)
      .reject { |piece| piece.same_color?(@queen) }
      .map { |piece| board.position(piece) }
      .uniq
  end

  # private

  def all_diagonal_pieces
    moves         = @queen.potential_moves(from)
    left_to_right = pieces_on_diagonal(moves[:left_to_right])
    right_to_left = pieces_on_diagonal(moves[:right_to_left])
    
    enclosed_inclusive_subset(left_to_right) + enclosed_inclusive_subset(right_to_left)
  end

  def rank_and_file_pieces
    moves       = @queen.potential_moves(from)
    rank_pieces = pieces_on_rank_or_file(moves[:rank_array])
    file_pieces = pieces_on_rank_or_file(moves[:file_array])
    
    enclosed_inclusive_subset(rank_pieces) + enclosed_inclusive_subset(file_pieces)
  end

  def pieces_on_diagonal(diagonal)
    board.current_positions.values_at(*diagonal)
  end
end

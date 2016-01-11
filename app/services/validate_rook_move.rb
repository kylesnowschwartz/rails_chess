class ValidateRookMove < ValidatePieceMove
  def legal_moves
    rank_and_file_pieces
      .reject { |piece| piece.same_color?(@rook) }
      .map { |piece| board.position(piece) }
      .uniq
  end

  # private

  def rank_and_file_pieces
    moves       = @rook.potential_moves(from)
    rank_pieces = pieces_on_rank_or_file(moves[:rank_array])
    file_pieces = pieces_on_rank_or_file(moves[:file_array])
    
    enclosed_inclusive_subset(rank_pieces) + enclosed_inclusive_subset(file_pieces)
  end

  def pieces_on_rank_or_file(rank_or_file)
    board.current_positions.values_at(*rank_or_file)
  end
end
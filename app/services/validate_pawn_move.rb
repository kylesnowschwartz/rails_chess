class ValidatePawnMove < ValidatePieceMove
  def legal_moves
    valid_attacks + valid_moves_forward
  end

  # private

  def valid_attacks
    return [] if @pawn.potential_moves(from)[:attacks].empty?

    @pawn.potential_moves(from)[:attacks].select do |attack|
      board.piece(attack).present? &&
        board.piece(attack).opposite_color?(@pawn) &&
        Square.position_diagonals(from).flatten.include?(to)
    end
  end

  def valid_moves_forward
    return [] if @pawn.potential_moves(from)[:moves_forward].empty?

    @pawn.potential_moves(from)[:moves_forward].select do |move_forward|
      board.piece(move_forward).nil_piece? &&
      board.piece(Square.one_row_ahead(from, @pawn)).nil_piece?
    end
  end
end
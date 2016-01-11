class ValidatePawnMove < ValidatePieceMove
  def legal_moves
    valid_attacks + valid_moves_forward
  end

  # private

  def valid_attacks
    return [] if @pawn.potential_moves(from)[:attacks].empty?

    @pawn.potential_moves(from)[:attacks].select do |position|
      board.piece(position).present? &&
        board.piece(position).opposite_color?(@pawn) &&
        Square.position_diagonals(from).flatten.include?(to)
    end
  end

  def valid_moves_forward
    return [] if @pawn.potential_moves(from)[:moves_forward].empty?

    @pawn.potential_moves(from)[:moves_forward].select do |position|
      board.piece(position).nil_piece?
    end
  end
end
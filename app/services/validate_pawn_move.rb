class ValidatePawnMove < ValidatePieceMove
  def potential_moves
    valid_attacks + valid_moves_forward
  end

  # private

  def valid_attacks
    return [] if @pawn.possible_placements(from)[:attacks].empty?
    @pawn.possible_placements(from)[:attacks].select do |attack|
      board.piece(attack).present? &&
      board.piece(attack).opposite_color?(@pawn)
    end
  end

  def valid_moves_forward
    return [] if @pawn.possible_placements(from)[:moves_forward].empty?

    @pawn.possible_placements(from)[:moves_forward].select do |move_forward|
      board.piece(move_forward).nil_piece? &&
      board.piece(Position.new(from).n_rows_ahead(1, @pawn.color)).nil_piece?
    end
  end
end
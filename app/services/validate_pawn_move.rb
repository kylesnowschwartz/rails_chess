class ValidatePawnMove < ValidatePieceMove
  def legal_moves
    @pawn.potential_moves(from).select do |position|
      valid_attack?(position) || valid_move?(position)
    end
  end

  # private

  def valid_attack?(position)
    board.piece(position).present? &&
      board.piece(position).opposite_color?(@pawn) &&
      Square.position_diagonals(from).flatten.include?(to)
  end

  def valid_move?(position)
    board.piece(position).nil_piece?
  end
end

move e2 e4
move d7 d5
move e4 e5
move f7 f6
move g1 f3
move d5 e4
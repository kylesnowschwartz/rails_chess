class ValidatePawnMove < ValidatePieceMove
  def call
    (valid_attack? || valid_move?) && @pawn.potential_moves(from).include?(to)
  end

  private

  def valid_attack?
    piece_on_desired_square.present? &&
      piece_on_desired_square.opposite_color?(@pawn) &&
      Square.position_diagonals(from).flatten.include?(to)
  end

  def valid_move?
    piece_on_desired_square.nil_piece?
  end
end
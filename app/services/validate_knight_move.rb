class ValidateKnightMove < ValidatePieceMove
  def call
    valid_move? && @knight.potential_moves(from).include?(to)
  end

  # private

  def valid_move?
    piece_on_desired_square.nil_piece? || piece_on_desired_square.opposite_color?(@knight)
  end
end
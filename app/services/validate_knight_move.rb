class ValidateKnightMove < ValidatePieceMove
  def legal_moves
    @knight.potential_moves(from).select do |position|
      piece = board.piece(position)

      piece.opposite_color?(@knight) || piece.nil_piece?
    end
  end
end
class ValidateKnightMove < ValidatePieceMove
  def potential_moves
    @knight.possible_placements(from).select do |position|
      piece = board.piece(position)

      piece.opposite_color?(@knight) || piece.nil_piece?
    end
  end
end
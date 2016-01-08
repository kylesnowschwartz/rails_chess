class ValidateKingMove < ValidatePieceMove
  def call
    valid_move? && @king.potential_moves(from).include?(to)
  end

  # private

  def valid_move?
    (piece_on_desired_square.nil_piece? || piece_on_desired_square.opposite_color?(@king)) && !moves_through_check?
  end

  def moves_through_check?
    opposite_color_positions.map do |position_list| 
      position_list.is_a?(Array) ? position_list : position_list.values 
    end.flatten.uniq.include?(to)
  end

  def opposite_color_pieces
    board.current_positions.select { |piece| piece.opposite_color?(@king) }
  end

  def opposite_color_positions
    opposite_color_pieces.map { |piece| piece.potential_moves(board.position(piece)) }
  end
end
class ValidateKingMove < ValidatePieceMove
  def call
    legal_moves.include?(to)
  end

  def legal_moves
    @king.potential_moves(from).reject do |position|
      board.piece(position).same_color?(@king) || moves_into_check?(position)
    end
  end

  # private
  
  def moves_into_check?(position)
    @duped_board = duplicate_board
    move_king_in_duplicated_board(position)

    return true if kings_meeting?

    opposite_color_pieces_moves_attack_desired_king_move?(position)
  end

  def opposite_color_pieces_moves_attack_desired_king_move?(position)
    opposite_color_pieces_without_king.map do |opposite_piece|
      "Validate#{opposite_piece.class}Move".constantize.new(
        opposite_piece, @duped_board, @duped_board.position(opposite_piece), position
      ).call
    end.any?
  end

  def move_king_in_duplicated_board(position)
    @duped_board.current_positions[position] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  def kings_meeting?
    king_index = @duped_board.current_positions.find_index(opposite_color_king)
    opposite_color_king.potential_moves(king_index).include?(to)
  end
end
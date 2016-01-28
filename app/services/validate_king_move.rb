class ValidateKingMove < ValidatePieceMove
  def call
    potential_moves.include?(to)
  end

  def potential_moves
    # TODO make this reject the moves into check stuff once
    potential_standard_moves + potential_castles
  end

  private

  def potential_standard_moves
    @king.possible_placements(from)[:moves].reject do |position|
      board.piece(position).same_color?(@king) || moves_into_check?(position)
    end
  end

  def potential_castles
    if can_castle?
      @king.possible_placements(from)[:castles].reject do |position|
        board.piece(position).same_color?(@king) || moves_into_check?(position)
      end
    else
      []
    end
  end

  def can_castle?
    if attempting_queen_side_castle?
      queen_side_piece.is_a?(Rook) && 
      !queen_side_piece.has_moved &&
      !queen_side_castle_moves_through_check?
    elsif attempting_king_side_castle?
      king_side_piece.is_a?(Rook) && 
      !king_side_piece.has_moved &&
      !king_side_castle_moves_through_check?
    else
      false
    end &&
    !piece_in_question.has_moved &&
    not_in_check? 
  end

  def queen_side_castle_moves_through_check?
    if @king.white?
      opposite_color_pieces_attack_desired_king_move?(King::WHITE_QUEEN_SIDE_CASTLE_ROOK_TO)
    else
      opposite_color_pieces_attack_desired_king_move?(King::BLACK_QUEEN_SIDE_CASTLE_ROOK_TO)
    end
  end

  def king_side_castle_moves_through_check?
    if @king.white?
      opposite_color_pieces_attack_desired_king_move?(King::WHITE_KING_SIDE_CASTLE_ROOK_TO)
    else
      opposite_color_pieces_attack_desired_king_move?(King::BLACK_KING_SIDE_CASTLE_ROOK_TO)
    end
  end

  def attempting_queen_side_castle?
    to == @king.possible_placements(from)[:castles][0]
  end

  def attempting_king_side_castle?
    to == @king.possible_placements(from)[:castles][1]
  end

  def queen_side_piece
    subset_of_pieces_that_bound_king[0]
  end

  def king_side_piece
    subset_of_pieces_that_bound_king[-1]
  end

  def subset_of_pieces_that_bound_king
    rank = Position.new(from).rank
    pieces = pieces_on_rank_or_file(rank)
    enclosed_inclusive_subset(pieces)
  end
  
  def moves_into_check?(position)
    @duped_board = duplicate_board
    move_king_in_duplicated_board(position)

    kings_meeting? || opposite_color_pieces_attack_desired_king_move?(position)
  end

  def not_in_check?
    @duped_board = duplicate_board

    kings_position = @duped_board.position(same_color_king)

    opposite_color_pieces_potential_moves.exclude?(kings_position)
  end

  def opposite_color_pieces_attack_desired_king_move?(move)
    opposite_color_pieces_without_king.any? do |opposite_piece|
      dummy_validator(opposite_piece, move).call
    end
  end

  def move_king_in_duplicated_board(position)
    @duped_board.current_positions[position] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  def kings_meeting?
    king_index = @duped_board.current_positions.find_index(opposite_color_king)
    opposite_color_king.possible_placements(king_index)[:moves].include?(to)
  end

  def opposite_color_pieces_without_king
    opposite_color_pieces.reject { |piece| piece.class == King}
  end
end
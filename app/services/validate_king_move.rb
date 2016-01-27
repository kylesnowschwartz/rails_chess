class ValidateKingMove < ValidatePieceMove
  def call
    legal_moves.include?(to)
  end

  def legal_moves
    @king.potential_moves(from)[:moves].reject do |position|
      board.piece(position).same_color?(@king) || moves_into_check?(position)
    end +
    @king.potential_moves(from)[:castles].select do |position|
      can_castle?(position) && !moves_into_check?(position)
    end.uniq
  end

  # private

  # TODO extract this to a service query
  def can_castle?(position)
    queen_side_position = @king.potential_moves(from)[:castles][0]
    king_side_position = @king.potential_moves(from)[:castles][1]
    rank = Square.rank(from)
    pieces = pieces_on_rank_or_file(rank)
    subset_of_pieces_that_bound_king = enclosed_inclusive_subset(pieces)
    left_bound_piece = subset_of_pieces_that_bound_king[0]
    right_bound_piece = subset_of_pieces_that_bound_king[-1]

    if to == queen_side_position
      left_bound_piece.is_a?(Rook) && 
      original_rook_positions[0] == @board.position(left_bound_piece) &&
      left_bound_piece.has_moved == false
    elsif to == king_side_position
      right_bound_piece.is_a?(Rook) && 
      original_rook_positions[1] == @board.position(right_bound_piece) &&
      right_bound_piece.has_moved == false
    else
      false
    end &&
    piece_in_question.has_moved == false &&
    original_king_position == from &&
    !my_color_king_in_check? &&
    position == to
  end

  def original_king_position
    piece_in_question.white? ? 60 : 4
  end

  def original_rook_positions
    piece_in_question.white? ? [56, 63] : [0, 7]
  end
  
  def moves_into_check?(position)
    @duped_board = duplicate_board
    move_king_in_duplicated_board(position)

    kings_meeting? || opposite_color_pieces_attack_desired_king_move?(position)
  end

  def opposite_color_pieces_attack_desired_king_move?(position)
    opposite_color_pieces_without_king.any? do |opposite_piece|
      "Validate#{opposite_piece.class}Move".constantize.new(
        opposite_piece, @duped_board, @duped_board.position(opposite_piece), position
      ).call
    end
  end

  def move_king_in_duplicated_board(position)
    @duped_board.current_positions[position] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  def kings_meeting?
    king_index = @duped_board.current_positions.find_index(opposite_color_king)
    opposite_color_king.potential_moves(king_index)[:moves].include?(to)
  end
end
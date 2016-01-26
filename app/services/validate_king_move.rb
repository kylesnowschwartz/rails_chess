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

  # TODO make a test for each condition and extract this to a service query
  def can_castle?(position)
    # byebug
    queen_side_position = @king.potential_moves(from)[:castles][0]
    king_side_position = @king.potential_moves(from)[:castles][1]

    if @king.white? 
      return false unless from == 60 
    else 
      return false unless from == 4 
    end

    rank = Square.rank(from)

    pieces = pieces_on_rank_or_file(rank)
    subset = enclosed_inclusive_subset(pieces)

    front_piece = subset[0]
    back_piece = subset[-1]

    return false unless front_piece.is_a?(Rook) || back_piece.is_a?(Rook)

    if @king.white?
      return @board.position(front_piece) == 56 || @board.position(back_piece) == 63
    else
      return @board.position(front_piece) == 0 || @board.position(back_piece) == 7
    end

    return false if piece_in_question_pinned?

    # The king and the chosen rook are on the player's first rank
    # Neither the king nor the chosen rook has previously moved.
    # There are no pieces between the king and the chosen rook.
    # The king is not currently in check.
    # The king does not pass through a square that is attacked by an enemy piece
    # The king does not end up in check. (True of any legal move.)
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
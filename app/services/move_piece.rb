class MovePiece
  attr_reader :board, :piece, :from, :to, :validator

  def initialize(move)
    @board     = move.board
    @from      = move.from
    @to        = move.to
    @piece     = move.piece
    @validator = ValidatePieceMove.validator_for(move)
  end

  def call
    raise "You can't move from an empty square" if piece.nil_piece?

    if move_valid?      
      place_piece

      if piece.is_a?(Pawn) && [Board::RANK1, Board::RANK8].include?(Position.new(to).rank)
        promote_pawn
      end

      set_has_moved_to_true
    else
      raise "Not a legal move for #{piece.class}"
    end

    board
  end

  def skip_validation
    # TODO What should I call all this stuff?
    place_piece

    if piece.is_a?(Pawn) && [Board::RANK1, Board::RANK8].include?(Position.new(to).rank)
      promote_pawn
    end

    set_has_moved_to_true

    board
  end

  def report_king_status
    if opposing_player_in_checkmate?
      puts 'Checkmate.'
    elsif opposing_player_in_check?
      puts 'Check.'
    else
    end
  end

  # private

  def place_piece
    board.current_positions[to] = board.current_positions[from]
    board.current_positions[from] = NilPiece.new

    if is_castling?
      place_castles
    end
  end

  def set_has_moved_to_true
    @board.piece(to).has_moved = true
    @board.piece(from).has_moved = true
  end
    
  def move_valid?
    @validator.call
  end

  def opposing_player_in_check?
    @validator.opposite_color_king_in_check?
    # verifier = KingInCheckVerifier.new(@board)
    # @piece.white? ? verifier.black_king_in_check? : verifier.white_king_in_check?
  end

  def opposing_player_in_checkmate?
    @validator.opposite_color_king_in_checkmate?
  end

  def is_castling?
    @piece.is_a?(King) &&
    from == @piece.original_position &&
    @piece.possible_placements(from)[:castles].include?(to)
  end

  def place_castles
    if [King::WHITE_QUEEN_SIDE_CASTLE_TO, King::BLACK_QUEEN_SIDE_CASTLE_TO].include?(to)
      place_queen_side_castle
    else
      place_king_side_castle
    end
  end

  def place_queen_side_castle
    if piece.white?
      board.current_positions[King::WHITE_QUEEN_SIDE_CASTLE_ROOK_TO] = board.current_positions[King::WHITE_QUEEN_SIDE_CASTLE_ROOK_FROM]
      board.current_positions[King::WHITE_QUEEN_SIDE_CASTLE_ROOK_FROM] = NilPiece.new
    else
      board.current_positions[King::BLACK_QUEEN_SIDE_CASTLE_ROOK_TO] = board.current_positions[King::BLACK_QUEEN_SIDE_CASTLE_ROOK_FROM]
      board.current_positions[King::BLACK_QUEEN_SIDE_CASTLE_ROOK_FROM] = NilPiece.new
    end
  end

  def place_king_side_castle
    if piece.white?
      board.current_positions[King::WHITE_KING_SIDE_CASTLE_ROOK_TO] = board.current_positions[King::WHITE_KING_SIDE_CASTLE_ROOK_FROM]
      board.current_positions[King::WHITE_KING_SIDE_CASTLE_ROOK_FROM] = NilPiece.new
    else
      board.current_positions[King::BLACK_KING_SIDE_CASTLE_ROOK_TO] = board.current_positions[King::BLACK_KING_SIDE_CASTLE_ROOK_FROM]
      board.current_positions[King::BLACK_KING_SIDE_CASTLE_ROOK_FROM] = NilPiece.new
    end
  end

  def promote_pawn
    # TODO for now, let's just choose a queen for pawn promotions
    # chosen_piece = request_pawn_promotion_choice
    chosen_piece = "Queen"

    board.current_positions[to] = chosen_piece.constantize.new(piece.color)
  end

  def request_pawn_promotion_choice
    loop do
      puts "Please choose a piece (Queen, Knight, Bishop, Rook)"
      choice = gets.capitalize.chomp
      return choice if ["Queen", "Rook", "Bishop", "Knight"].include?(choice)
    end
  end
end


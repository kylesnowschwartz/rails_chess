class MovePiece
  attr_reader :board, :piece, :from, :to

  def initialize(board, from, to)
    @board = board
    @from  = from
    @to    = to
    @piece = board.piece(from)
  end

  def call
    raise "You can't move from an empty square" if piece.nil_piece?

    if move_valid?
      report_king_status
      
      place_piece

      set_has_moved_to_true
      
      promote_pawn
    else
      raise "Not a legal move for #{piece.class}"
    end

    board
  end

  # private

  def report_king_status
    if opposing_player_in_checkmate?
      puts 'Checkmate.'
    elsif checked_opposing_player?
      puts 'Check.'
    else
    end
  end

  def castling?
    @piece.is_a?(King) && @piece.potential_moves(from)[:castles].include?(to)
  end

  def place_piece
    board.current_positions[to] = board.current_positions[from]
    board.current_positions[from] = NilPiece.new

    if castling?
      king_side_castle_to = 62
      king_side_castle_rook_from = 63
      king_side_castle_rook_to = 61

      if to == king_side_castle_to
        board.current_positions[king_side_castle_rook_to] = board.current_positions[king_side_castle_rook_from]
        board.current_positions[king_side_castle_rook_from] = NilPiece.new
      end

      if to == 58
        board.current_positions[59] = board.current_positions[56]
        board.current_positions[56] = NilPiece.new
      end
    end
  end

  def set_has_moved_to_true
    @board.piece(to).has_moved = true
    @board.piece(from).has_moved = true
  end
    
  def move_valid?
    "Validate#{piece.class}Move".constantize.new(piece, board, from, to).call
  end

  def checked_opposing_player?
    "Validate#{piece.class}Move".constantize.new(piece, board, from, to).opposite_color_king_in_check?
  end

  def opposing_player_in_checkmate?
    "Validate#{piece.class}Move".constantize.new(piece, board, from, to).opposite_color_king_in_checkmate?
  end

  def promote_pawn
    if piece.is_a?(Pawn) && [Board::RANK1, Board::RANK8].any? { |rank| rank == Square.rank(to) }
      chosen_piece = request_pawn_promotion_choice

      board.current_positions[to] = chosen_piece.constantize.new(piece.color)
    end
  end

  def request_pawn_promotion_choice
    loop do
      puts "Please choose a piece (Queen, Knight, Bishop, Rook)"
      choice = gets.capitalize.chomp
      return choice if ["Queen", "Rook", "Bishop", "Knight"].include?(choice)
    end
  end
end


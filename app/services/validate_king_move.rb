class ValidateKingMove
  attr_reader :king, :board, :to, :from, :piece_on_desired_square

  def initialize(king, board, from, to)
    @king  = king
    @board = board
    @to    = to
    @from  = from
    @piece_on_desired_square = board.piece(to)
  end

  def call
    valid_move? && king.potential_moves(from).include?(to)
  end

  # private

  def valid_move?
    (piece_on_desired_square.nil_piece? || piece_on_desired_square.opposite_color?(king)) && !moves_through_check?
  end

  def moves_through_check?
    @duped_board = duplicate_board
    move_king_in_duplicated_board

    return true if kings_meeting?

    opposite_color_pieces_without_king.map do |piece|
      "Validate#{piece.class}Move".constantize.new(piece, @duped_board, @duped_board.position(piece), to).call
    end.any?
  end

  def duplicate_board
    duplicated_board = Board.new 
    duplicated_board.current_positions = board.current_positions.map(&:dup)
    duplicated_board
  end

  def move_king_in_duplicated_board
    @duped_board.current_positions[to] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  def opposite_color_pieces
    @duped_board.current_positions.select { |piece| piece.opposite_color?(king) }
  end

  def opposite_color_pieces_without_king
    opposite_color_pieces.reject { |piece| piece.class == King}
  end

  def opposite_color_king 
    opposite_color_pieces.select { |piece| piece.class == King }[0]
  end

  def kings_meeting?
    king_index = @duped_board.position(opposite_color_king)
    opposite_color_king.potential_moves(king_index).include?(to)
  end
end


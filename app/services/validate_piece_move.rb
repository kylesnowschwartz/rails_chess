class ValidatePieceMove
  attr_reader :board, :to, :from

  def initialize(piece, board, from, to)
    @to                      = to
    @from                    = from
    @board                   = board
    @piece_name              = piece.class.to_s.downcase

    instance_variable_set("@#{@piece_name}", piece)
  end

  def call
    !move_leaves_king_in_check? && legal_moves.include?(to)
  end

  # private

  def piece_in_question
    instance_variable_get("@#{@piece_name}")
  end

  def move_leaves_king_in_check?
    @duped_board = duplicate_board
    move_piece_in_duplicated_board

    kings_position = @duped_board.position(same_color_king)
    opposite_color_pieces_legal_moves.include?(kings_position)
  end

  def my_color_king_in_check?
    @duped_board = duplicate_board

    kings_position = @duped_board.position(same_color_king)

    opposite_color_pieces_legal_moves.include?(kings_position)
  end

  def opposite_color_king_in_check?
    @duped_board = duplicate_board
    move_piece_in_duplicated_board

    kings_position = @duped_board.position(opposite_color_king)

    same_color_pieces_legal_moves.include?(kings_position)
  end

  def duplicate_board
    duplicated_board = Board.new 
    duplicated_board.current_positions = @board.current_positions.map(&:dup)
    duplicated_board
  end

  def move_piece_in_duplicated_board
    @duped_board.current_positions[to] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  # TODO perhaps the board knows about the black and white pieces?

  def opposite_color_king_in_checkmate?
    return false unless opposite_color_king_in_check?
    
    @duped_board = duplicate_board
    move_piece_in_duplicated_board

    validated_opposite_color_pieces_legal_moves.empty?
  end

  def validated_opposite_color_pieces_legal_moves
    opposite_color_pieces.map do |opposite_piece|
      validated_moves_for_piece(opposite_piece)
    end.flatten
  end

  def legal_moves_for_piece(piece)
    "Validate#{piece.class}Move".constantize.new(piece, @duped_board, @duped_board.position(piece), nil).legal_moves
  end

  def validated_moves_for_piece(piece)
    legal_moves_for_piece(piece).select do |move|
      "Validate#{piece.class}Move".constantize.new(piece, @duped_board, @duped_board.position(piece), move).call
    end
  end

  def opposite_color_pieces_legal_moves
    opposite_color_pieces.map do |opposite_piece|
      "Validate#{opposite_piece.class}Move".constantize.new(opposite_piece, @duped_board, @duped_board.position(opposite_piece), nil).legal_moves
    end.flatten.uniq
  end

  def same_color_pieces_legal_moves
    same_color_pieces_without_king.map do |opposite_piece|
      "Validate#{opposite_piece.class}Move".constantize.new(opposite_piece, @duped_board, @duped_board.position(opposite_piece), nil).legal_moves
    end.flatten.uniq
  end

  def opposite_color_pieces
    @duped_board.current_positions.select { |piece| piece.opposite_color?(piece_in_question) }
  end

  def same_color_pieces
    @duped_board.current_positions.select { |piece| piece.same_color?(piece_in_question) }
  end

  def opposite_color_pieces_without_king
    opposite_color_pieces.reject { |piece| piece.class == King}
  end

  def same_color_pieces_without_king
    same_color_pieces.reject { |piece| piece.class == King}
  end

  def opposite_color_king 
    opposite_color_pieces.select { |piece| piece.class == King }[0]
  end

  def same_color_king
    same_color_pieces.select { |piece| piece.class == King }[0]
  end

  def pieces_on_rank_or_file(rank_or_file)
    board.current_positions.values_at(*rank_or_file)
  end

  def enclosed_inclusive_subset(pieces)
    return [] if pieces.empty?

    starting_position  = pieces.find_index(piece_in_question)
    partitioned_pieces = pieces.partition.with_index { |piece, index| index <= starting_position}
    behind_subset      = partitioned_pieces[0]
    ahead_subset       = partitioned_pieces[1]
    piece_in_question  = behind_subset.pop

    left_bound = []
    behind_subset.reverse_each do |piece|
      left_bound << piece
      break unless piece.nil_piece?
    end

    right_bound = []
    ahead_subset.each do |piece|
      right_bound << piece
      break unless piece.nil_piece?
    end

    left_bound.reverse + right_bound
  end
end
class ValidatePieceMove
  attr_reader :board, :to, :from, :move

  def initialize(move)
    @move       = move
    @to         = move.to
    @from       = move.from
    @board      = move.board
    @piece_name = move.piece.class.to_s.downcase

    instance_variable_set("@#{@piece_name}", move.piece)
  end

  def self.validator_for(move)
    "Validate#{move.piece.class}Move".constantize.new(move)
  end

  def dummy_validator(piece, to = nil)
    move = Move.new(@duped_board, piece, @duped_board.position(piece), to)

    "Validate#{piece.class}Move".constantize.new(move)
  end

  def call
    !move_leaves_king_in_check? && potential_moves.include?(to)
  end

  # TODO move these to queries
  def opposite_color_king_in_checkmate?
    return false unless opposite_color_king_in_check?
    
    @duped_board = @board.dup
    move_piece_in_duplicated_board

    validated_opposite_color_pieces_potential_moves.empty?
  end

  def opposite_color_king_in_check?
    @duped_board = @board.dup
    move_piece_in_duplicated_board

    kings_position = @duped_board.position(opposite_color_king)

    same_color_pieces_potential_moves.include?(kings_position)
  end

  private

  def piece_in_question
    instance_variable_get("@#{@piece_name}")
  end

  def move_leaves_king_in_check?
    @duped_board = @board.dup
    move_piece_in_duplicated_board

    kings_position = @duped_board.position(same_color_king)
    opposite_color_pieces_potential_moves.include?(kings_position)
  end

  def same_color_pieces_potential_moves
    same_color_pieces_without_king.map do |opposite_piece|
      dummy_validator(opposite_piece).potential_moves
    end.flatten.uniq
  end

  def validated_opposite_color_pieces_potential_moves
    opposite_color_pieces.map do |opposite_piece|
      validated_moves_for_piece(opposite_piece)
    end.flatten
  end

  def validated_moves_for_piece(piece)
    potential_moves_for_piece(piece).select do |move|
      dummy_validator(piece, move).call
    end
  end

  def potential_moves_for_piece(piece)
    dummy_validator(piece).potential_moves
  end

  def same_color_pieces_without_king
    same_color_pieces.reject { |piece| piece.class == King}
  end

  def opposite_color_king
    opposite_color_pieces.select { |piece| piece.class == King }[0]
  end

  def pieces_on_rank_or_file(rank_or_file)
    board.current_positions.values_at(*rank_or_file)
  end

  def opposite_color_pieces_potential_moves
    opposite_color_pieces.map do |opposite_piece|
      dummy_validator(opposite_piece).potential_moves
    end.flatten.uniq
  end

  def opposite_color_pieces
    @duped_board ||= @board.dup

    @duped_board.current_positions.select { |piece| piece.opposite_color?(piece_in_question) }
  end

  def same_color_king
    same_color_pieces.select { |piece| piece.class == King }[0]
  end

  def same_color_pieces
    @duped_board.current_positions.select { |piece| piece.same_color?(piece_in_question) }
  end

  def move_piece_in_duplicated_board
    @duped_board.current_positions[to] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  def enclosed_inclusive_subset(pieces)
    return [] if pieces.empty?
    left_bound = []
    right_bound = []

    # TODO take while - capture the index rather than piece itself
    partitioned_pieces(pieces)[:behind_subset].reverse_each do |piece|
      left_bound << piece
      break unless piece.nil_piece?
    end

    partitioned_pieces(pieces)[:ahead_subset].each do |piece|
      right_bound << piece
      break unless piece.nil_piece?
    end

    left_bound.reverse + right_bound
  end

  def partitioned_pieces(pieces)
    starting_position = pieces.find_index(piece_in_question)

    partitions = pieces.partition.with_index { |_, index| index <= starting_position }

    { behind_subset: partitions[0][0..-2], ahead_subset: partitions[1] }
  end
end

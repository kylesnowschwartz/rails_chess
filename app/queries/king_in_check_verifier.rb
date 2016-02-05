class KingInCheckVerifier
  attr_reader :board
  
  def initialize(board)
    @board = board
  end

  def white_king_in_check?
    black_pieces_potential_moves.include?(black_kings_position)
  end

  def black_king_in_check?
    white_pieces_potential_moves.include?(black_kings_position)
  end

  # private

  def white_pieces
    @board.current_positions.select { |piece| piece.white? }
  end

  def black_pieces
    @board.current_positions.select { |piece| piece.black? }
  end

  def black_pieces_potential_moves
    black_pieces.map do |black_piece|
      dummy_validator(black_piece).potential_moves
    end.flatten
  end

  def white_pieces_potential_moves
    white_pieces.map do |white_piece|
      dummy_validator(white_piece).potential_moves
    end.flatten
  end

  def white_king
    white_pieces.select { |piece| piece.is_a?(King) }
  end

  def white_kings_position
    board.position(white_king)
  end

  def black_kings_position
    board.position(black_king)
  end

  def black_king
    black_pieces.select { |piece| piece.is_a?(King) }
  end

  def dummy_validator(piece, to = nil)
    move = Move.new(@board, piece, @board.position(piece), to)

    "Validate#{piece.class}Move".constantize.new(move)
  end
end
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

  private

  def valid_move?
    piece_on_desired_square.nil_piece? || piece_on_desired_square.opposite_color?(king)
  end

  def does_not_move_through_check?
    opposite_color_pieces = board.current_positions.select { |piece| piece.opposite_color?(king) }
    # TODO finish up making sure a king does not move into or through check
  end
end
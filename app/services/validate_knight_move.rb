class ValidateKnightMove
  attr_reader :knight, :board, :to, :from, :piece_on_desired_square

  def initialize(knight, board, from, to)
    @knight  = knight
    @board = board
    @to    = to
    @from  = from
    @piece_on_desired_square = board.piece(to)
  end

  def call
    valid_move? && knight.potential_moves(from).include?(to)
  end

  # private

  def valid_move?
    piece_on_desired_square.nil_piece? || piece_on_desired_square.opposite_color?(knight)
  end
end
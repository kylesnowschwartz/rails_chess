class Move
  attr_reader :piece, :from, :to, :board

  def initialize(board, piece, from, to = nil)
    @board = board
    @piece = piece
    @from  = from
    @to    = to
  end
end
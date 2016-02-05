class BuildPosition
  attr_reader :board, :turns

  def initialize(turns)
    @board = CreateBoard.new.call
    @turns = turns
  end

  def call
    @turns.each do |turn|
      to   = turn.to_square
      from = turn.from_square
      move = Move.new(@board, @board.piece(from), from, to)
      MovePiece.new(move).skip_validation
    end

    @board
  end
end
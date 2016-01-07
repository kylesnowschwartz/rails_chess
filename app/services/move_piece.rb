class MovePiece
  attr_reader :board, :piece, :from, :to

  def initialize(board, from, to)
    @board = board
    @from  = from
    @to    = to
    @piece = board.piece(from)
  end

  def call
    if move_valid?
      board.current_positions[to] = board.current_positions[from]
      board.current_positions[from] = NilPiece.new

      if piece.is_a?(Pawn) && (Square.rank(to) == Board::RANK1 || Square.rank(to) == Board::RANK8)
        promote_pawn
      end
    else
      raise 'Not a legal move.'
    end

    board
  end

  private

  def move_valid?
    "Validate#{piece.class}Move".constantize.new(piece, board, from, to).call
  end

  def promote_pawn
    board.current_positions[to] = request_pawn_promotion_choice.constantize.new(piece.color)
  end

  def request_pawn_promotion_choice
    loop do
      puts "Please choose a piece (Queen, Knight, Bishop, Rook)"
      choice = gets.capitalize.chomp
      return choice if ["Queen", "Rook", "Bishop", "Knight"].include?(choice)
    end
  end
end


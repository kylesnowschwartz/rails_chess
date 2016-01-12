class CreateBoard
  def call
    @board = Board.new
    set_initial_positions
    @board
  end

  def set_initial_positions
    populate_pawns
    populate_other_pieces("white")
    populate_other_pieces("black")
    populate_blank_squares
  end

  def populate_pawns
    Board::RANK2
      .each { |position| @board.current_positions[position] = Pawn.new("white") }
    Board::RANK7
      .each { |position| @board.current_positions[position] = Pawn.new("black") }
  end

  def populate_other_pieces(color)
    other_pieces = [
      Rook.new(color), Knight.new(color), Bishop.new(color), Queen.new(color), 
      King.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)
    ]

    case color
    when "white"
      Board::RANK1
        .each { |position| @board.current_positions[position] = other_pieces.shift }
    when "black"
      Board::RANK8
        .each { |position| @board.current_positions[position] = other_pieces.shift }
    else
      raise "Sorry, white and black are the only valid options. I know, das racist"
    end
  end

  def populate_blank_squares
    initially_blank_ranks = [Board::RANK3, Board::RANK4, Board::RANK5, Board::RANK6]

    initially_blank_ranks.each do |rank|
      rank.each { |position| @board.current_positions[position] = NilPiece.new }
    end
  end
end
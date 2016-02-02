class CreateBoard
  def call
    @board = Board.new
    set_initial_positions
    @board
  end

  # private

  def set_initial_positions
    populate_pawns
    populate_other_pieces(White.new)
    populate_other_pieces(Black.new)
    populate_blank_squares
  end

  def populate_pawns
    Board::RANK2.each do |position| 
      @board.current_positions[position] = Square.new(Position.new(position), Pawn.new(White.new))
    end
    
    Board::RANK7.each do |position| 
      @board.current_positions[position] = Square.new(Position.new(position), Pawn.new(Black.new))
    end
  end

  def populate_other_pieces(color)
    other_pieces = [
      Rook.new(color), Knight.new(color), Bishop.new(color), Queen.new(color), 
      King.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)
    ]

    if color == White.new then rank = Board::RANK1 else rank = Board::RANK8 end

    rank.each_with_index { |position, i| @board.current_positions[position] = Square.new(Position.new(position), other_pieces[i]) }
  end

  def populate_blank_squares
    initially_blank_ranks = [Board::RANK3, Board::RANK4, Board::RANK5, Board::RANK6]

    initially_blank_ranks.each do |rank|
      rank.each { |position| @board.current_positions[position] = Square.new(Position.new(position)) }
    end
  end
end
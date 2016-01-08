class Pawn < Piece
  def potential_moves(position)
    @position = position

    moves = []

    moves << one_ahead
  
  # TODO enpassant
  # the capturing pawn must be on its fifth rank;
  # the captured pawn must be on an adjacent file 
    # and must have just moved two squares in a single move (i.e. a double-step move);
  # the capture can only be made on the move immediately 
    # after the opposing pawn makes the double-step move; 
    # otherwise the right to capture it en passant is lost.
    
    if white?
      moves << two_ahead if Square.rank(position) == Board::RANK2
      moves << attack_right unless on_file_h?(position)
      moves << attack_left unless on_file_a?(position)
    else
      moves << two_ahead if Square.rank(position) == Board::RANK7
      moves << attack_right unless on_file_a?(position)
      moves << attack_left unless on_file_h?(position)
    end

    Square.positions_within_board(moves)
  end

  def one_head
    Square.one_row_ahead(@position, self)
  end

  def two_ahead
    Square.two_rows_ahead(@position, self)
  end

  def attack_left
    Square.one_diagonal_forward_left(@position, self)
  end

  def attack_right
    Square.one_diagonal_forward_right(@position, self)
  end
end
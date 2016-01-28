class Pawn < Piece
  def possible_placements(position)
    @position = position

    attacks = []
    moves_forward = []

    moves_forward << one_ahead
  
  # TODO enpassant
  # the capturing pawn must be on its fifth rank;
  # the captured pawn must be on an adjacent file 
    # and must have just moved two squares in a single move (i.e. a double-step move);
  # the capture can only be made on the move immediately 
    # after the opposing pawn makes the double-step move; 
    # otherwise the right to capture it en passant is lost.
    
    if white?
      moves_forward << two_ahead if Square.rank(position) == Board::RANK2
      attacks << attack_right unless on_file_h?(position)
      attacks << attack_left unless on_file_a?(position)
    else
      moves_forward << two_ahead if Square.rank(position) == Board::RANK7
      attacks << attack_right unless on_file_a?(position)
      attacks << attack_left unless on_file_h?(position)
    end

    { 
      attacks: Square.positions_within_board(attacks),
      moves_forward: Square.positions_within_board(moves_forward)
    }
  end

  def one_ahead
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
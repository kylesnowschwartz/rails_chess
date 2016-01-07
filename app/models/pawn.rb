class Pawn < Piece
  def potential_moves(position)
    moves        = []
    one_ahead    = Square.one_row_ahead(position, self)
    two_ahead    = Square.two_rows_ahead(position, self)
    attack_left  = Square.one_diagonal_forward_left(position, self)
    attack_right = Square.one_diagonal_forward_right(position, self)

    moves << one_ahead
  
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

  # TODO enpassant
end
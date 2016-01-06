class Pawn < Piece
  def legal_moves(board, position)
    @moves = []

    one_ahead     = Square.one_row_ahead(position, self)
    @two_ahead    = Square.two_rows_ahead(position, self)
    @attack_left  = Square.one_diagonal_forward_left(position, self)
    @attack_right = Square.one_diagonal_forward_right(position, self)

    @moves << one_ahead unless board.current_positions[one_ahead].present?
    
    if white?
      process_white_moves(board, position)
    else
      process_black_moves(board, position)
    end

    moves_within_board(@moves)
  end

  def process_white_moves(board, position)
    if Square.rank(position) == Board::RANK2
      @moves << @two_ahead unless board.current_positions[@two_ahead].present?
    end

    if board.current_positions[@attack_right].present? && board.current_positions[@attack_right].black?
      @moves << @attack_right if !on_file_h?(position)
    end

    if board.current_positions[@attack_left].present? && board.current_positions[@attack_left].black?
      @moves << @attack_left if !on_file_a?(position)
    end
  end

  def process_black_moves(board, position)
    if Square.rank(position) == Board::RANK7
      @moves << @two_ahead unless board.current_positions[@two_ahead].present?
    end

    if board.current_positions[@attack_right].present? && board.current_positions[@attack_right].white?
      @moves << @attack_right if !on_file_a?(position)
    end
      
    if board.current_positions[@attack_left].present? && board.current_positions[@attack_left].white?
      @moves << @attack_left if !on_file_h?(position)
    end
  end
end
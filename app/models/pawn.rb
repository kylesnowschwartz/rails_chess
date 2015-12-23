class Pawn < Piece
  def legal_moves(board, position)
    potential_moves(board, position).select { |position| within_board?(position) }
  end

  def potential_moves(board, position)
    moves = []

    two_ahead = two_rows_ahead(position)
    one_ahead = one_row_ahead(position)
    attack_left = attack_left(position)
    attack_right = attack_right(position)

    moves << one_ahead unless board.current_positions[one_ahead].present?
    
    if white?
      if Board::RANK2.include?(position)
        moves << two_ahead unless board.current_positions[two_ahead].present?
      end

      moves << attack_right if board.current_positions[attack_right].present? && !on_file_h?(position)
      
      moves << attack_left if board.current_positions[attack_left].present? && !on_file_a?(position)
    end

    if black?
      if Board::RANK7.include?(position)
        moves << two_ahead unless board.current_positions[two_ahead].present?
      end

      moves << attack_right if board.current_positions[attack_right].present? && !on_file_a?(position)
      
      moves << attack_left if board.current_positions[attack_left].present? && !on_file_h?(position)
    end

    moves
  end

  def two_rows_ahead(position)
    white? ? position - 16 : position + 16
  end

  def one_row_ahead(position)
    white? ? position - 8 : position + 8
  end

  def attack_left(position)
    white? ? position - 9 : position + 9
  end
  
  def attack_right(position)
    white? ? position - 7 : position + 7
  end
end
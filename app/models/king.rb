class King < Piece
  # def legal_moves(board, position)
  #   potential_moves(board, position).select { |position| within_board?(position) }
  # end

  # def potential_moves(board, position)
  #   [
  #     [row    , col - 1], 
  #     [row    , col + 1], 
  #     [row - 1, col    ], 
  #     [row + 1, col    ], 
  #     [row - 1, col - 1], 
  #     [row + 1, col + 1],
  #     [row - 1, col + 1], 
  #     [row + 1, col - 1] 
  #   ].select { |coordinate| is_valid?(coordinate) }
  # end
end
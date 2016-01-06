class Rook < Piece
  def legal_moves(board, position)
    rank_and_file_pieces(board, position)
      .reject { |piece| same_color?(piece) }
      .map { |piece| board.current_positions.find_index(piece) }
  end

  def rank_and_file_pieces(board, position)
    rank_pieces = pieces_on_rank_or_file(board, rank_array(position))
    file_pieces = pieces_on_rank_or_file(board, file_array(position))

    enclosed_inclusive_subset(rank_pieces) + enclosed_inclusive_subset(file_pieces)
  end

  def rank_array(position)
    rank = Square.rank(position).to_a
  end
  
  def file_array(position)
    file = Square.file(position).to_a
  end

  def pieces_on_rank_or_file(board, rank_or_file)
    board.current_positions.values_at(*rank_or_file)
  end

  def enclosed_inclusive_subset(rank_or_file_pieces)
    starting_position = rank_or_file_pieces.find_index(self)
    ahead_subset = []
    behind_subset = []

    Board::WIDTH.times do |offset|
      offset += 1
      ahead = rank_or_file_pieces[starting_position + offset]
      behind = rank_or_file_pieces[starting_position - offset]
      
      if  ahead_subset.empty? || ahead_subset.last.try(:nil_piece?)
        ahead_subset << ahead if [ahead].any?
      end

      if  behind_subset.empty? || behind_subset.last.try(:nil_piece?)
        behind_subset << behind if [behind].any?
      end
    end

    behind_subset + ahead_subset
  end
end

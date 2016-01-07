class ValidateQueenMove
  attr_reader :queen, :board, :to, :from

  def initialize(queen, board, from, to)
    @queen  = queen
    @board = board
    @to    = to
    @from  = from
  end

  def call
    legal_moves.include?(to)
  end

  # private

  def legal_moves
    all_diagonal_pieces + rank_and_file_pieces
      .reject { |piece| queen.same_color?(piece) }
      .map { |piece| board.current_positions.find_index(piece) }
      .uniq
  end

  def all_diagonal_pieces
    moves         = queen.potential_moves(from)
    left_to_right = pieces_on_diagonal(moves[:left_to_right])
    right_to_left = pieces_on_diagonal(moves[:right_to_left])
    
    enclosed_inclusive_subset(left_to_right) + enclosed_inclusive_subset(right_to_left)
  end

  def pieces_on_diagonal(diagonal)
    board.current_positions.values_at(*diagonal)
  end

  def rank_and_file_pieces
    moves       = queen.potential_moves(from)
    rank_pieces = pieces_on_rank_or_file(moves[:rank_array])
    file_pieces = pieces_on_rank_or_file(moves[:file_array])
    
    enclosed_inclusive_subset(rank_pieces) + enclosed_inclusive_subset(file_pieces)
  end

  def pieces_on_rank_or_file(rank_or_file)
    board.current_positions.values_at(*rank_or_file)
  end

  def enclosed_inclusive_subset(pieces)
    starting_position = pieces.find_index(queen)
    ahead_subset = []
    behind_subset = []

    Board::WIDTH.times do |offset|
      offset += 1
      ahead = pieces[starting_position + offset]
      behind = pieces[starting_position - offset] if starting_position - offset >= 0
      
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
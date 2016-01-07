class ValidateRookMove
  attr_reader :rook, :board, :to, :from

  def initialize(rook, board, from, to)
    @rook  = rook
    @board = board
    @to    = to
    @from  = from
  end

  def call
    legal_moves.include?(to)
  end

  private

  def legal_moves
    rank_and_file_pieces
      .reject { |piece| rook.same_color?(piece) }
      .map { |piece| board.current_positions.find_index(piece) }
      .uniq
  end

  def rank_and_file_pieces
    moves       = rook.potential_moves(from)
    rank_pieces = pieces_on_rank_or_file(moves[:rank_array])
    file_pieces = pieces_on_rank_or_file(moves[:file_array])
    
    enclosed_inclusive_subset(rank_pieces) + enclosed_inclusive_subset(file_pieces)
  end

  def pieces_on_rank_or_file(rank_or_file)
    board.current_positions.values_at(*rank_or_file)
  end

  def enclosed_inclusive_subset(pieces)
    starting_position = pieces.find_index(rook)
    ahead_subset = []
    behind_subset = []

    Board::WIDTH.times do |offset|
      offset += 1
      ahead = pieces[starting_position + offset]
      behind = pieces[starting_position - offset]
      
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
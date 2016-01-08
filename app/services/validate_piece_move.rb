class ValidatePieceMove
  attr_reader :board, :to, :from, :piece_on_desired_square

  def initialize(piece, board, from, to)
    @to                      = to
    @from                    = from
    @board                   = board
    @piece_name              = piece.class.to_s.downcase
    @piece_on_desired_square = board.piece(to)

    instance_variable_set("@#{@piece_name}", piece)
  end

  def piece_in_question
    instance_variable_get("@#{@piece_name}")
  end

  def enclosed_inclusive_subset(pieces)
    starting_position = pieces.find_index(piece_in_question)
    ahead_subset      = []
    behind_subset     = []

    Board::WIDTH.times do |offset|
      offset += 1
      behind  = pieces[starting_position - offset]
      ahead   = pieces[starting_position + offset] if starting_position - offset >= 0
      
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
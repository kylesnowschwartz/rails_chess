class ValidatePieceMove
  attr_reader :board, :to, :from

  def initialize(piece, board, from, to)
    @to                      = to
    @from                    = from
    @board                   = board
    @piece_name              = piece.class.to_s.downcase

    instance_variable_set("@#{@piece_name}", piece)
  end

  def call
    !piece_in_question_pinned? && legal_moves.include?(to)
  end

  # private

  def piece_in_question
    instance_variable_get("@#{@piece_name}")
  end

  def piece_in_question_pinned?
    @duped_board = duplicate_board
    move_piece_in_duplicated_board

    my_color_king_in_check?
  end

  def duplicate_board
    duplicated_board = Board.new 
    duplicated_board.current_positions = @board.current_positions.map(&:dup)
    duplicated_board
  end

  def move_piece_in_duplicated_board
    @duped_board.current_positions[to] = @duped_board.current_positions[from]
    @duped_board.current_positions[from] = NilPiece.new
  end

  # TODO perhaps the board knows about the black and white pieces?

  def my_color_king_in_check?
    kings_position = @duped_board.position(same_color_king)

    opposite_color_pieces_legal_moves.include?(kings_position)
  end

  def opposite_color_king_in_check?
    @duped_board = duplicate_board
    move_piece_in_duplicated_board

    kings_position = @duped_board.position(opposite_color_king)

    same_color_pieces_legal_moves.include?(kings_position)
  end

  def opposite_color_pieces_legal_moves
    opposite_color_pieces_without_king.map do |opposite_piece|
      "Validate#{opposite_piece.class}Move".constantize.new(opposite_piece, @duped_board, @duped_board.position(opposite_piece), nil).legal_moves
    end.flatten.uniq
  end

  def same_color_pieces_legal_moves
    same_color_pieces_without_king.map do |opposite_piece|
      "Validate#{opposite_piece.class}Move".constantize.new(opposite_piece, @duped_board, @duped_board.position(opposite_piece), nil).legal_moves
    end.flatten.uniq
  end

  def opposite_color_pieces
    @duped_board.current_positions.select { |piece| piece.opposite_color?(piece_in_question) }
  end

  def same_color_pieces
    @duped_board.current_positions.select { |piece| piece.same_color?(piece_in_question) }
  end

  def opposite_color_pieces_without_king
    opposite_color_pieces.reject { |piece| piece.class == King}
  end

  def same_color_pieces_without_king
    same_color_pieces.reject { |piece| piece.class == King}
  end

  def opposite_color_king 
    opposite_color_pieces.select { |piece| piece.class == King }[0]
  end

  def same_color_king
    same_color_pieces.select { |piece| piece.class == King }[0]
  end

  def enclosed_inclusive_subset(pieces)
    return [] if pieces.empty?

    starting_position = pieces.find_index(piece_in_question)
    ahead_subset      = []
    behind_subset     = []

    Board::WIDTH.times do |offset|
      offset += 1
      behind  = pieces[starting_position - offset] if starting_position - offset >= 0
      ahead   = pieces[starting_position + offset]
      
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
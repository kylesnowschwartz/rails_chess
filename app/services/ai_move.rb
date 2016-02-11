class AIMove
  attr_reader :game, :board, :random_piece, :move, :validator, :errors

  def initialize(game)
    @game = game
    @board = BuildPosition.new(game.turns).call    
    @errors = [] 
  end

  def call
    black_potential_moves = pieces_potential_moves(black_pieces)
  
    random = pieces_validated_moves(black_potential_moves).sample
    random_move = random[:moves].select { |move| @board.position(move).present? }.sample || random[:moves].sample

    if random
      @game.turns.create!(to_square: random_move, from_square: @board.position(random[:piece]))
    else
      errors << "!!!! CHECKMATE !!!!"
    end

    errors.none?
  end

  def black_pieces
    @board.current_positions.select { |pieces| pieces.black? }
  end

  def potential_moves(piece)
    dummy_move = Move.new(@board, piece, @board.position(piece))

    validator = ValidatePieceMove.validator_for(dummy_move)

    { piece: piece, moves: validator.potential_moves }
  end

  def pieces_potential_moves(pieces)
    pieces
      .map { |piece| potential_moves(piece) }
      .select { |piece_info| piece_info[:moves].any? }
  end

  def pieces_validated_moves(pieces_info)
    pieces_info.map do |piece_info|
      piece = piece_info[:piece]
      moves = piece_info[:moves]

      validated_moves = moves.select do |move| 
        current_move = Move.new(@board, piece, @board.position(piece), move)

        ValidatePieceMove.validator_for(current_move).call
      end

      {piece: piece, moves: validated_moves}
    end.select { |piece_info| piece_info[:moves].any?}
  end
end
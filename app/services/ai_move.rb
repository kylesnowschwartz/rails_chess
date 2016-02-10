class AIMove
  attr_reader :game, :board, :random_piece, :move, :validator

  def initialize(game)
    @game = game
    @board = BuildPosition.new(game.turns).call     
  end

  def call
    black_pieces_moves = black_pieces.map do |piece|
      validator_for_piece(piece)
    end.select { |piece_info| piece_info[:moves].any?}

    p random = black_pieces_moves.sample

    @new_move = Move.new(@board, random[:piece], @board.position(random[:piece]), random[:moves].sample)


    @game.turns.create!(to_square: @new_move.to, from_square: @new_move.from)
  end

  def black_pieces
    @board.current_positions.select { |pieces| pieces.black? }
  end

  def validator_for_piece(piece)
    dummy_move = Move.new(@board, piece, @board.position(piece))

    validator = ValidatePieceMove.validator_for(dummy_move)

    {piece: piece, moves: validator.potential_moves}
  end
end
class AIMove
  attr_reader :game, :board, :random_piece, :move, :validator

  def initialize(game)
    @game = game
    @board = BuildPosition.new(game.turns).call     
  end

  def call
    300.times do
      piece_info = validator_for_random_piece
      
      @new_move = Move.new(@board, piece_info[:piece], @board.position(piece_info[:piece]), piece_info[:move])
      
      if piece_info[:move].present?
        break if ValidatePieceMove.validator_for(@new_move).call
      end
    end

    @game.turns.create!(to_square: @new_move.to, from_square: @new_move.from)
  end

  def random_piece
    @board.current_positions.select { |pieces| pieces.black? }.sample
  end

  def validator_for_random_piece
    piece = random_piece

    dummy_move = Move.new(@board, piece, @board.position(piece))

    validator = ValidatePieceMove.validator_for(dummy_move)

    move = validator.potential_moves.sample

    {piece: piece, move: move}
  end
end
class TurnsController < ApplicationController
  def create
    game  = Game.find(params[:game_id])

    to    = translate_rank_file_notation_to_position(params[:to])
    from  = translate_rank_file_notation_to_position(params[:from])
    
    board = BuildPosition.new(game.turns).call
    piece = board.piece(from)
    
    move  = Move.new(board, piece, from,  to)
    move_piece = MovePiece.new(move)

    if move_piece.validator.call && whose_turn?(game) == piece.color
      game.turns.create!(to_square: to, from_square: from)

      if game.players.last.token == "AI"
        AIMove.new(game).call
      end
    end

    redirect_to game
  end

  private

  def whose_turn?(game)
    num_of_turns = game.turns.count

    num_of_turns.even? ? White.new : Black.new
  end
end

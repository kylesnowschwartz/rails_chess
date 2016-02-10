class PlayersController < ApplicationController
  def update
    game = Game.find(params[:game_id])
    player = Player.find(params[:id])
    player.update!(token: params[:token])
    redirect_to game
  end
end

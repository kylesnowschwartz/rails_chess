class GamesController < ApplicationController
  def index
    @games = Game.last(5)
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create!

    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])

    turns = @game.turns

    p @board = BuildPosition.new(turns).call
  end
end

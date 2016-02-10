class CreateGame
  def call
    game = Game.create!
    game.players.create!(token: SecureRandom.hex)
    game.players.create!(token: nil)
    game
  end
end
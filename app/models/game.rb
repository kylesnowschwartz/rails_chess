class Game < ActiveRecord::Base
  has_many :turns, dependent: :destroy
end


# Game.joins(:turns).group("games.id").order("count(turns.id) DESC")
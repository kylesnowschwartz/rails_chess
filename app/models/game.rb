class Game < ActiveRecord::Base
  has_many :turns, dependent: :destroy
  has_many :players, dependent: :destroy
end
class Game < ActiveRecord::Base
  has_many :moves, dependent: :destroy
end

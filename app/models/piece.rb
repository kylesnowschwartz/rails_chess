class Piece
  attr_reader :color

  def initialize(args = {})
    @color = args[:color]
  end
end
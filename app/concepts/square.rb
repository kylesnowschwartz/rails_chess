class Square
  attr_accessor :piece
  attr_reader :position
  
  def initialize(position, piece)
    @position = position
    @piece = piece
  end
end
class Square
  attr_accessor :piece
  attr_reader :position

  def initialize(position, piece = nil)
    @position = position
    @piece = piece
  end

  def piece
    # TODO So I'm still asking questions about pieces that don't exit, I don't want to have to constantly
    # 'try' things or ask if they 'respond to' stuff 
  end
end
class White < Color
  def initialize
    @color_string = 'white'
  end

  def opposite_color
    Black.new
  end

  def white?
    true
  end
end
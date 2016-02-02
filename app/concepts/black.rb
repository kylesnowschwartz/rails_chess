class Black < Color
  def initialize
    @color_string = 'black'
  end

  def opposite_color
    White.new
  end

  def black?
    true
  end
end
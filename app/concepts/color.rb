class Color
  attr_reader :color_string

  def initialize(color_string = nil)
    @color_string = color_string
  end

  def ==(other)
    @color_string == other.color_string
  end

  def white?
    @color_string == 'white'
  end

  def black?
    @color_string == 'black'
  end

  def opposite_color
    false
  end

  def same_color
    false
  end

  def to_s
    @color_string
  end
end
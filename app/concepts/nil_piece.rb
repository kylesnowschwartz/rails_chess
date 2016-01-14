class NilPiece < Piece
  def initialize
    @color = nil
  end

  def present?
    false
  end
end
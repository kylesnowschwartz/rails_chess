class Knight < Piece
  def possible_placements(position)
    Position.new(position).knight_moves
  end
end
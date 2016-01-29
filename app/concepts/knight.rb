class Knight < Piece
  def possible_placements(position_id)
    knight_moves(position_id)
  end

  def knight_moves(position_id)
    position ||= Position.new(position_id)
    row = position.position_to_coordinate.row
    col = position.position_to_coordinate.column
    
    [
      [row - 2, col + 1], 
      [row + 2, col + 1], 
      [row - 2, col - 1], 
      [row + 2, col - 1], 
      [row - 1, col - 2], 
      [row - 1, col + 2], 
      [row + 1, col - 2], 
      [row + 1, col + 2], 
    ].select { |c| position.valid_coordinate?(c) }
     .map { |c| position.coordinate_to_position(c) }
  end
end
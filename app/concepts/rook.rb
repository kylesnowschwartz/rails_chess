class Rook < Piece
  def possible_placements(position)
    {
      rank_array: rank_array(position),
      file_array: file_array(position)
    }
  end

  private

  def rank_array(position)
    Position.new(position).rank.to_a
  end
  
  def file_array(position)
    Position.new(position).file.to_a
  end
end

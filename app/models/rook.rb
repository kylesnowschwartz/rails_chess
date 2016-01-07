class Rook < Piece
  def potential_moves(position)
    {
      rank_array: rank_array(position), 
      file_array: file_array(position)
    }
  end

  private

  def rank_array(position)
    Square.rank(position).to_a
  end
  
  def file_array(position)
    Square.file(position).to_a
  end
end

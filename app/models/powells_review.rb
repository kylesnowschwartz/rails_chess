def valid_move?(piece, from, to)
end

def valid_move?(move)
end



class Knight < Piece
  def moves_from(position)
    [
      KnightMove.new(...),
      ...

    ]
  end

end

class KnightMove < Move
  def validator
    @validator ||= KnightMoveValidator.new(self)
  end
end
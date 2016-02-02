class Pawn < Piece
  def possible_placements(position_id)
    @position_id = position_id

    attacks = []
    moves_forward = []

    moves_forward << one_ahead
   
    if white?
      moves_forward << two_ahead if Position.new(@position_id).rank == Board::RANK2
      attacks << attack_right unless on_file_h?(position_id)
      attacks << attack_left unless on_file_a?(position_id)
    else
      moves_forward << two_ahead if Position.new(@position_id).rank == Board::RANK7
      attacks << attack_right unless on_file_a?(position_id)
      attacks << attack_left unless on_file_h?(position_id)
    end

    { 
      attacks: Position.new(@position_id).positions_within_board(attacks),
      moves_forward: Position.new(@position_id).positions_within_board(moves_forward)
    }
  end

  private

  def one_ahead
    Position.new(@position_id).one_row_ahead(self.color)
  end

  def two_ahead
    Position.new(@position_id).two_rows_ahead(self.color)
  end

  def attack_left
    Position.new(@position_id).one_diagonal_forward_left(self.color)
  end

  def attack_right
    Position.new(@position_id).one_diagonal_forward_right(self.color)
  end
end

# TODO enpassant
# the capturing pawn must be on its fifth rank;
# the captured pawn must be on an adjacent file 
  # and must have just moved two squares in a single move (i.e. a double-step move);
# the capture can only be made on the move immediately 
  # after the opposing pawn makes the double-step move; 
  # otherwise the right to capture it en passant is lost.

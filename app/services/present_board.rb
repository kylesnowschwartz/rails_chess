class PresentBoard
  PIECES_TO_UNICODE = { 
    "white King"   => "\u2654",
    "white Queen"  => "\u2655",
    "white Rook"   => "\u2656",
    "white Bishop" => "\u2657",
    "white Knight" => "\u2658",
    "white Pawn"   => "\u2659",
    "black King"   => "\u265A",
    "black Queen"  => "\u265B",
    "black Rook"   => "\u265C",
    "black Bishop" => "\u265D",
    "black Knight" => "\u265E",
    "black Pawn"   => "\u265F"
  }
  
  def call(board)
    @board = board
    
    join_board_with_new_lines
  end

  private

  def map_pieces_to_visual_representations
    @board.current_positions.map do |piece| 
      piece.nil_piece? ? "   " : PIECES_TO_UNICODE["#{piece.color} #{piece.class}"].center(3)
    end.in_groups_of(8)
  end

  def colorize_squares
    map_pieces_to_visual_representations.map.with_index do |row, index|
      if index.even? 
        row.map.with_index { |piece, index| index.even? ? piece.on_light_white : piece.on_black }
      else 
        row.map.with_index { |piece, index| index.odd? ? piece.on_light_white : piece.on_black }
      end
    end
  end

  def apply_rank_and_file_labels
    colorize_squares
      .zip( (1..8).to_a.reverse.map { |number| number.to_s.center(3) } )
      .unshift(("A".."H").to_a.map { |letter| letter.center(3) } )
  end

  def pad_top_and_bottom
    apply_rank_and_file_labels
      .unshift(["\n"])
      .push(["\n"])
  end

  def join_board_with_new_lines
    pad_top_and_bottom
      .map(&:join)
      .join("\n")
  end
end
class Board
  attr_accessor :current_positions

  # TODO extract set up to a service
  # TODO extract presentation to a presenter
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

  WIDTH = 8

  RANK1 = (56..63)
  RANK2 = (48..55)
  RANK3 = (40..47)
  RANK4 = (32..39)
  RANK5 = (24..31)
  RANK6 = (16..23)
  RANK7 = (8..15) 
  RANK8 = (0..7)

  FILEA = (0..56).step(8)
  FILEB = (1..57).step(8)
  FILEC = (2..58).step(8)
  FILED = (3..59).step(8)
  FILEE = (4..60).step(8)
  FILEF = (5..61).step(8)
  FILEG = (6..62).step(8)
  FILEH = (7..63).step(8)

  POSITIONS = [RANK8, RANK7, RANK6, RANK5, RANK4, RANK3, RANK2, RANK1].map(&:to_a)

  def initialize
    @current_positions = []
    set_initial_positions
  end

  def inspect
    @current_positions
      .map { |piece| piece.nil_piece? ? "   " : PIECES_TO_UNICODE["#{piece.color} #{piece.class}"].center(3) }
      .in_groups_of(8)
      .map.with_index do |row, index|
        if index.even? 
          row.map.with_index { |piece, index| index.even? ? piece.on_light_white : piece.on_black }
        else 
          row.map.with_index { |piece, index| index.odd? ? piece.on_light_white : piece.on_black }
        end
      end
      .zip( (1..8).to_a.reverse.map { |number| number.to_s.center(3) } )
      .unshift(("A".."H").to_a.map { |letter| letter.center(3) } )
      .unshift(["\n"])
      .map { |row| row.join }
      .push(["\n"])
      .join("\n")
  end

  def piece(position)
    current_positions[position]
  end

  def position(piece)
    current_positions.find_index(piece)
  end

  private

  def set_initial_positions
    populate_pawns
    populate_other_pieces("white")
    populate_other_pieces("black")
    populate_blank_squares
  end

  def populate_pawns
    RANK2.each { |position| @current_positions[position] = Pawn.new("white") }
    RANK7.each { |position| @current_positions[position] = Pawn.new("black") }
  end

  def populate_other_pieces(color)
    other_pieces = [Rook.new(color), Knight.new(color), Bishop.new(color), Queen.new(color), 
                    King.new(color), Bishop.new(color), Knight.new(color), Rook.new(color)]

    case color
    when "white"
      RANK1.each { |position| @current_positions[position] = other_pieces.shift}
    when "black"
      RANK8.each { |position| @current_positions[position] = other_pieces.shift}
    else
      raise "Sorry, white and black are the only valid options. I know, das racist"
    end
  end

  def populate_blank_squares
    initially_blank_ranks = [RANK3, RANK4, RANK5, RANK6]

    initially_blank_ranks.each do |rank|
      rank.each { |position| @current_positions[position] = NilPiece.new }
    end
  end
end
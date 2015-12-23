class Board
  attr_reader :current_positions

  WIDTH = 8
  RANK1 = (56..63), FILEA = (0..56).step(8)
  RANK2 = (48..55), FILEB = (1..57).step(8)
  RANK3 = (40..47), FILEC = (2..58).step(8)
  RANK4 = (32..39), FILED = (3..59).step(8)
  RANK5 = (24..31), FILEE = (4..60).step(8)
  RANK6 = (16..23), FILEF = (5..61).step(8)
  RANK7 = (8..15) , FILEG = (6..62).step(8)
  RANK8 = (0..7)  , FILEH = (7..63).step(8)

  def initialize
    @current_positions = []
    set_initial_positions
  end

  def move_piece(from_square, to_square)
    legal_moves = @current_positions[from_square].legal_moves(self, from_square)

    if legal_moves.include?(to_square)
      @current_positions[to_square] = @current_positions[from_square]
      @current_positions[from_square] = nil
    else
      raise 'Not a legal move.'
    end

    self
  end

  def inspect
    @current_positions.
      map { |piece| piece.nil? ? "".center(8) : "#{piece.class}".center(8).colorize(piece.color.to_sym) }.
      in_groups_of(8).
      map.with_index do |row, index|
        index.even? ? row.map.with_index { |piece, index| index.even? ? piece.on_light_white : piece.on_light_black } : row.map.with_index { |piece, index| index.odd? ? piece.on_light_white : piece.on_light_black }
      end.
      unshift(["\n"]).
      map{ |row| row.join }.
      push(["\n"]).
      join("\n" + " "*71 + "\n")
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
      rank.each { |position| @current_positions[position] = nil }
    end
  end
end
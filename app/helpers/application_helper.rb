module ApplicationHelper
end

module ChessDSL
  FILE_LETTERS = ('a'..'h').to_a.zip((0..7).to_a).to_h
  RANK_NUMBERS = (1..8).to_a.zip((0..7).to_a.reverse).to_h

  def self.set_notation_variables
    ('a'..'h').each do |letter|
      ('1'..'8').each do |number|
        variable_name = letter + number

        define_method(variable_name.to_sym) do |*args| 
          args.empty? ? variable_name : [variable_name, args[0]]
        end
      end
    end
  end

  set_notation_variables

  def start_chess
    ActiveRecord::Base.logger.level = 1 # turn off database logging in console
    
    @game = Game.create!
    @board = CreateBoard.new.call
  end

  def move((from, to))
    from = chess_notation_to_position(from)
    to = chess_notation_to_position(to)
    piece = @board.piece(from)

    move = Move.new(@board, piece, from, to)

    if ValidatePieceMove.validator_for(move).call && @game
      @game.turns.create!(from_square: from, to_square: to)
    end

    move_piece = MovePiece.new(move)
    move_piece.report_king_status
    move_piece.call
  end

  def chess_notation_to_position(notation)
    file, rank = notation.chars[0], notation.chars[1].to_i

    coordinate = [RANK_NUMBERS[rank], FILE_LETTERS[file]]

    Position.new.coordinate_to_position(coordinate)
  end

  def to(argument)
    argument
  end
end   

class Object
  include ChessDSL
end
module ApplicationHelper
end

module ChessDSL
  def start_chess
    ActiveRecord::Base.logger.level = 1 # turn off database logging in console
    
    @game = Game.create!
    @board = CreateBoard.new.call
  end

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

  def to(argument)
    argument
  end

  def move((from, to))
    from = translate_rank_file_notation_to_position(from)
    to = translate_rank_file_notation_to_position(to)
    piece = @board.piece(from)

    if "Validate#{piece.class}Move".constantize.new(piece, @board, from, to).call && @game
      Move.create!(game: @game, from_square: from, to_square: to)
    end

    #TODO instantiate move piece, then call it, then ask it some questions
    # begin
      MovePiece.new(@board, from, to).call
    # rescue Exception => e
    #   puts e.message
    # end
  end

  def translate_rank_file_notation_to_position(notation)
    file_letters = ('a'..'h').to_a.zip((0..7).to_a).to_h
    rank_numbers = (1..8).to_a.zip((0..7).to_a.reverse).to_h

    file, rank = notation.chars[0], notation.chars[1].to_i

    coordinate = [rank_numbers[rank], file_letters[file]]

    Square.coordinate_to_position(coordinate)
  end
end   

class Object
  include ChessDSL
end
def start_chess
  set_notation_variables
  @board = CreateBoard.new.call
end

def set_notation_variables
  ('a'..'h').each do |letter|
    (1..8).each do |number|
      variable_name = letter + number.to_s

      define_method(variable_name.to_sym) { |*args| args.empty? ? variable_name : [variable_name, args[0]] } 
    end
  end
end

def to(argument)
  argument
end

def move((from, to))
  from = translate_rank_file_notation_to_position(from)
  to = translate_rank_file_notation_to_position(to)
  
  begin
    MovePiece.new(@board, from, to).call
  rescue Exception => e
    puts e.message
  end
end

def translate_rank_file_notation_to_position(notation)
  file_letters = ('a'..'h').to_a.zip( (0..7).to_a ).to_h
  rank_numbers = (1..8).to_a.zip( (0..7).to_a.reverse ).to_h
  
  begin
    file, rank = notation.chars[0], notation.chars[1].to_i

    coordinate = [ rank_numbers[rank], file_letters[file] ]

    Square.coordinate_to_position(coordinate)
  rescue Exception => e
    puts e.message
  end
end
require 'rails_helper'

RSpec.describe King, type: :concept do
  let(:empty_board) do 
    @board = Board.new
    64.times { @board.current_positions << NilPiece.new }
    @board
  end

  let(:kings_only_board) do 
    @board = empty_board
    @board.current_positions[36] = King.new('white')
    @board.current_positions[34] = King.new('black')
    @board
  end

  it "can move onto an empty square" do
    board = kings_only_board

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                         8 
                         7 
                         6 
             ♔           5 
       ♚                 4 
                         3 
                         2 
                         1
    BOARD

    move e4 e5

    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error trying to move to a square occupied with a piece of the same color" do
    board = kings_only_board
    board.current_positions[28] = Pawn.new('white')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                         8 
                         7 
                         6 
             ♙           5 
       ♚     ♔           4 
                         3 
                         2 
                         1
    BOARD

    expect{ move e4 e5 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "can move onto a square occupied with a piece of the opposite color" do
    board = kings_only_board
    board.current_positions[28] = Pawn.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                         8 
                         7 
                         6 
             ♔           5 
       ♚                 4 
                         3 
                         2 
                         1
    BOARD

    move e4 e5
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error if kings try to meet" do
    board = kings_only_board

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                         8 
                         7 
                         6 
                         5 
       ♚     ♔           4 
                         3 
                         2 
                         1
    BOARD

    expect{ move e4 d4 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error trying to move a king into check" do
    board = kings_only_board
    board.current_positions[5] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                ♜        8 
                         7 
                         6 
                         5 
       ♚     ♔           4 
                         3 
                         2 
                         1
    BOARD

    expect{ move e4 f4 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error attempting to move a pinned piece" do
    board = kings_only_board
    board.current_positions[28] = Rook.new('white')
    board.current_positions[4] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♜           8 
                         7 
                         6 
             ♖           5 
       ♚     ♔           4 
                         3 
                         2 
                         1
    BOARD

    expect{ move e5 f5 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "must move out of check" do
    board = kings_only_board
    board.current_positions[4] = Rook.new('black')
    board.current_positions[7] = Rook.new('white')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♜        ♖  8 
                         7 
                         6 
                         5 
       ♚     ♔           4 
                         3 
                         2 
                         1
    BOARD

    expect{ move e4 e5 }.to raise_error(RuntimeError)
    expect{ move h8 f8 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
   end

  it "allows checking pieces to be taken" do
    board = kings_only_board
    board.current_positions[4] = Rook.new('black')
    board.current_positions[7] = Rook.new('white')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♖           8 
                         7 
                         6 
                         5 
       ♚     ♔           4 
                         3 
                         2 
                         1
    BOARD

    move h8 e8
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "reports when a king is checked" do
    board = empty_board
    board.current_positions[63] = King.new('white')
    board.current_positions[56] = King.new('black')
    board.current_positions[8] = Rook.new('black')
    
    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                         8 
                      ♜  7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♚                    ♔  1
    BOARD

    expect(STDOUT).to receive(:puts).with("Check.")
    move a7 h7
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "reports when a king is mated" do
    @board = start_chess
    move f2 f3
    move e7 e5
    move g2 g4

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝     ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟     ♟  ♟  ♟  7 
                         6 
             ♟           5 
                   ♙  ♛  4 
                ♙        3 
 ♙  ♙  ♙  ♙  ♙        ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 


    BOARD

    expect(STDOUT).to receive(:puts).with("Checkmate.")
    move d8 h4
    expect(board_string.strip).to eq @board.inspect.strip
  end

  it "white king can castle king side" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[63] = Rook.new('white')
    @board.current_positions[4] = King.new('black')
    @board.current_positions[8] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
 ♜                       7 
                         6 
                         5 
                         4 
                         3 
                         2 
                ♖  ♔     1
    BOARD

    MovePiece.new(Move.new(board, board.piece(60), 60, 62)).call
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "white king can castle queen side" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[56] = Rook.new('white')
    @board.current_positions[4] = King.new('black')
    @board.current_positions[8] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
 ♜                       7 
                         6 
                         5 
                         4 
                         3 
                         2 
       ♔  ♖              1
    BOARD

    MovePiece.new(Move.new(board, board.piece(60), 60, 58)).call
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "black king can castle king side" do
    board = empty_board
    @board.current_positions[4] = King.new('black')
    @board.current_positions[7] = Rook.new('black')
    @board.current_positions[60] = King.new('white')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                ♜  ♚     8 
                         7 
                         6 
                         5 
                         4 
                         3 
                         2 
             ♔           1
    BOARD

    MovePiece.new(Move.new(board, board.piece(4), 4, 6)).call
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "black king can castle queen side" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[0] = Rook.new('black')
    @board.current_positions[4] = King.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
       ♚  ♜              8 
                         7 
                         6 
                         5 
                         4 
                         3 
                         2 
             ♔           1
    BOARD

    MovePiece.new(Move.new(board, board.piece(4), 4, 2)).call
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "cannot castle on the second rank" do
    board = empty_board
    board.current_positions[52] = King.new('white')
    board.current_positions[48] = Rook.new('white')
    board.current_positions[4] = King.new('black')
    board.current_positions[8] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
 ♜                       7 
                         6 
                         5 
                         4 
                         3 
 ♖           ♔           2 
                         1
    BOARD

    move = MovePiece.new(Move.new(board, board.piece(52), 52, 50))
    expect{ move.call }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip 
  end

  it "cannot castle when there is a piece in the way" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[56] = Rook.new('white')
    @board.current_positions[59] = Rook.new('white')
    @board.piece(59).has_moved = true
    @board.current_positions[4] = King.new('black')
    @board.current_positions[8] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
 ♜                       7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♖        ♖  ♔           1
    BOARD

    move = MovePiece.new(Move.new(@board, board.piece(60),  60, 58))
    expect{ move.call }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip 
  end

  it "cannot castle when in check" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[56] = Rook.new('white')
    @board.current_positions[4] = King.new('black')
    @board.current_positions[12] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
             ♜           7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♖           ♔           1
    BOARD

    move = MovePiece.new(Move.new(@board, board.piece(60),  60, 58))
    expect{ move.call }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip 
  end

  it "cannot castle when moving into check" do
       board = empty_board
       @board.current_positions[60] = King.new('white')
       @board.current_positions[56] = Rook.new('white')
       @board.current_positions[4] = King.new('black')
       @board.current_positions[10] = Rook.new('black')

       board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
       ♜                 7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♖           ♔           1
       BOARD

       move = MovePiece.new(Move.new(@board, board.piece(60),  60, 58))
       expect{ move.call }.to raise_error(RuntimeError)
       expect(board_string.strip).to eq board.inspect.strip 
  end

    it "cannot castle when moving through check" do
       board = empty_board
       @board.current_positions[60] = King.new('white')
       @board.current_positions[56] = Rook.new('white')
       @board.current_positions[4] = King.new('black')
       @board.current_positions[11] = Rook.new('black')

       board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
          ♜              7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♖           ♔           1
       BOARD

       move = MovePiece.new(Move.new(@board, board.piece(60),  60, 58))
       expect{ move.call }.to raise_error(RuntimeError)
       expect(board_string.strip).to eq board.inspect.strip 
  end

  it "cannot castle when the king has moved previously" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[56] = Rook.new('white')
    @board.current_positions[4] = King.new('black')
    @board.current_positions[8] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
 ♜                       7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♖           ♔           1
    BOARD

    move e1 e2
    move e2 e1
    move = MovePiece.new(Move.new(@board, board.piece(60),  60, 58))
    expect{ move.call }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "cannot castle when the rook has moved previously" do
    board = empty_board
    @board.current_positions[60] = King.new('white')
    @board.current_positions[56] = Rook.new('white')
    @board.current_positions[4] = King.new('black')
    @board.current_positions[8] = Rook.new('black')

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
             ♚           8 
 ♜                       7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♖           ♔           1
    BOARD

    move a1 a2
    move a2 a1
    move = MovePiece.new(Move.new(@board, board.piece(60),  60, 58))
    expect{ move.call }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end
end
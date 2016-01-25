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
    board = empty_board
    board.current_positions[63] = King.new('white')
    board.current_positions[56] = King.new('black')
    board.current_positions[6] = Rook.new('black')
    board.current_positions[8] = Rook.new('black')

         board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
                   ♜     8 
                      ♜  7 
                         6 
                         5 
                         4 
                         3 
                         2 
 ♚                    ♔  1
    BOARD

    expect(STDOUT).to receive(:puts).with("Checkmate.")
    move a7 h7
    expect(board_string.strip).to eq board.inspect.strip
   end
end
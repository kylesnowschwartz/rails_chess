require 'rails_helper'

RSpec.describe Pawn, type: :concept do
  let(:board) { start_chess }

  before do
    board
  end

  it "can move one space forward onto an empty square" do
    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟  7 
                         6 
                         5 
                         4 
             ♙           3 
 ♙  ♙  ♙  ♙     ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    move e2 e3
     
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "can move two spaces forward onto an empty square when starting from file 2" do
    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟  7 
                         6 
                         5 
             ♙           4 
                         3 
 ♙  ♙  ♙  ♙     ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    move e2 e4

    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error trying to move one space forward onto an occupied square" do

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟     ♟  ♟  ♟  7 
                         6 
             ♟           5 
             ♙           4 
                         3 
 ♙  ♙  ♙  ♙     ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    move e2 e4
    move e7 e5

    expect{ move e4 e5 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error trying to move two spaces forward through an occupied square" do
    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟     ♟  ♟  ♟  7 
                         6 
                         5 
                         4 
             ♟           3 
 ♙  ♙  ♙  ♙  ♙  ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    move e7 e5
    move e5 e4
    move e4 e3

    expect{ move e2 e4 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "moves diagonally onto an square occupied by an enemy piece" do

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟  ♟     ♟  ♟  7 
                         6 
                ♙        5 
                         4 
                         3 
 ♙  ♙  ♙  ♙     ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    move e2 e4
    move f7 f5
    move e4 f5

    expect(board_string.strip).to eq board.inspect.strip
  end

  it "raises an error trying attack an empty square" do

  board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟     ♟  ♟  ♟  7 
                         6 
             ♟           5 
             ♙           4 
                         3 
 ♙  ♙  ♙  ♙     ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    move e2 e4
    move e7 e5

    expect{ move e4 f5 }.to raise_error(RuntimeError)
    expect(board_string.strip).to eq board.inspect.strip
  end

  it "promotes pawns when they reach the other side of the board" do
    move g2 g4
    move h7 h5
    move g4 h5
    move h8 h6
    move e2 e4
    move h6 a6
    move h5 h6
    move h6 h7

    move = MovePiece.new(@board, 15, 7)
    allow(move).to receive_messages(gets: 'Queen')
    move.call

    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♕  8 
 ♟  ♟  ♟  ♟  ♟  ♟  ♟     7 
 ♜                       6 
                         5 
             ♙           4 
                         3 
 ♙  ♙  ♙  ♙     ♙     ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1
    BOARD

    expect(board_string.strip).to eq board.inspect.strip
  end

  it "can capture enpassant" do
    move b2 b4
    move h7 h5
    move b4 b5
    move a7 a5
    board_string = <<-BOARD
 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
    ♟  ♟  ♟  ♟  ♟  ♟     7 
                         6 
 ♙                    ♟  5 
                         4 
                         3 
 ♙     ♙  ♙  ♙  ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 
    BOARD

    expect{ move b5 a6 }.to_not raise_error
    expect(board_string.strip).to eq board.inspect.strip
  end
end


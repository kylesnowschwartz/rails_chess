require 'rails_helper'

RSpec.describe "Play game", type: :feature do
  it "It plays out a game" do
    board = Board.new
    board.move_piece(55, 39)
    board.move_piece(14, 30)
    board.move_piece(39, 30)
    board.move_piece(63, 15)
    board.move_piece(7, 15)
    board.move_piece(30, 22)
    board.move_piece(12, 28)
    board.move_piece(22, 15)
    expect(board.current_positions[15]).to be_a Pawn
    expect(board.current_positions[15].color).to eq 'white'
  end

  it 'has a string representation' do
    String.disable_colorization = true
    board = Board.new

    board_string = <<-BOARD


 A  B  C  D  E  F  G  H 
 ♜  ♞  ♝  ♛  ♚  ♝  ♞  ♜  8 
 ♟  ♟  ♟  ♟  ♟  ♟  ♟  ♟  7 
                         6 
                         5 
                         4 
                         3 
 ♙  ♙  ♙  ♙  ♙  ♙  ♙  ♙  2 
 ♖  ♘  ♗  ♕  ♔  ♗  ♘  ♖  1 


    BOARD
    board.move_piece(55, 39)

    expect(board_string.strip).to eq board.inspect.strip
  end
end

# simple game
# MovePiece.new(b, 54, 38).call
# MovePiece.new(b, 15, 31).call
# MovePiece.new(b, 38, 31).call
# MovePiece.new(b, 7, 23).call
# MovePiece.new(b, 55, 47).call
# MovePiece.new(b, 23, 16).call
# MovePiece.new(b, 31, 23).call
# MovePiece.new(b, 23, 15).call
# MovePiece.new(b, 15, 7).call
  
# ValidateKingMove 
start_chess
move e2 e4
move e1 e2
move e2 e3
move e3 f4
move d7 d5
move e8 d7
move d7 e6
move f4 e5

# reveal check
start_chess
move e2 e4
move e1 e2
move e2 e3
move e3 f4
move d7 d5
move e8 d7
move d7 e6
move f4 g4
move e6 d6
move a2 a3 # raises not a legal move

#promote Pawn
# start_chess
# move g2 g4
# move h7 h5
# move g4 h5
# move h8 h6
# move e2 e4
# move h6 a6
# move h5 h6
# move h6 h7
# move h7 h8
# move h8 g8

#put myself in check
start_chess
move e2 e4
move e7 e5
move d1 h5
move f7 f6
MovePiece.new(@board, 8, 16).my_color_king_in_check? == true
MovePiece.new(@board, 48, 40).opposite_color_king_in_check? == true

#pawn cannot attack blank square
start_chess
move e2 e4
move d7 d5
move e4 e5
move f7 f6
move g1 f3
move d5 e4















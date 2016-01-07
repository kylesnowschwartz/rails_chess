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
 board = Board.new
 king = board.piece(4)
 MovePiece.new(board, 11, 27).call
 MovePiece.new(board, 54, 46).call
 MovePiece.new(board, 61, 47).call
 MovePiece.new(board, 13, 21).call
 ValidateKingMove.new(king, board, 4, 11).call
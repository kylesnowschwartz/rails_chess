require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { CreateBoard.new.call }

   it 'has a string representation' do

     starting_board_string = <<-BOARD
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

     expect(starting_board_string.strip).to eq board.inspect.strip
   end
end

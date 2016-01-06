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
end
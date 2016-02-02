require 'rails_helper'

RSpec.describe KingInCheckVerifier, type: :query do
  let(:empty_board) do 
    @board = Board.new
    64.times { @board.current_positions << NilPiece.new }
    @board
  end

  it "verifies that a white king is in check" do
    @board = empty_board

  end

end
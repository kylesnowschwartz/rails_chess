require 'rails_helper'

RSpec.describe Board, type: :model do
  subject(:board) { Board.new }
  let(:white_pawn) { Pawn.new('white') }
  let(:black_pawn) { Pawn.new('black') }

# TODO wtf is happening with .color[:color] ?
  describe "Initial Position" do
    context "white pieces" do
      it "contains pawns in rank2" do
        subject.current_positions[48..55].each do |piece| 
          expect(piece).to be_a(Pawn)
          expect(piece.color).to eq 'white'
        end
      end
    end

    context "black pieces" do
      it "contains pawns in rank7" do
        subject.current_positions[8..15].each do |piece| 
          expect(piece).to be_a(Pawn)
          expect(piece.color).to eq 'black'
        end
      end
    end
  end
end

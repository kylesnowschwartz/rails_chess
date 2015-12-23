class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.references :game
      t.integer :from_square
      t.integer :to_square

      t.timestamps null: false
    end
  end
end

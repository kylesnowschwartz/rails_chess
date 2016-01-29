class RenameMoves < ActiveRecord::Migration
  def change
    rename_table :moves, :turns
  end
end

class AddDifficultyToCategory < ActiveRecord::Migration
  def change
		add_column :categories, :difficulty, :integer
  end
end

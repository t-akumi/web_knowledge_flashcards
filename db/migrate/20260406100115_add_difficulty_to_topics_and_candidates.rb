class AddDifficultyToTopicsAndCandidates < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :difficulty, :string, null: false, default: "beginner"
    add_column :topic_candidates, :difficulty, :string, null: false, default: "beginner"

    add_index :topics, :difficulty
    add_index :topic_candidates, :difficulty
  end
end

class CreateTopicCandidates < ActiveRecord::Migration[7.2]
  def change
    create_table :topic_candidates do |t|
      t.string :category
      t.string :title
      t.string :topic_type
      t.string :status

      t.timestamps
    end
  end
end

class CreateTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :topics do |t|
      t.string :category, null: false, default: "web_basics"
      t.string :title, null: false
      t.string :topic_type, null: false, default: "concept"
      t.string :status, null: false, default: "seeded"

      t.text :summary
      t.text :steps
      t.text :deep_dive
      t.jsonb :references, null: false, default: []
      t.datetime :generated_at

      t.timestamps
    end

    add_index :topics, [:category, :title], unique: true
    add_index :topics, :status
  end
end

class CreateHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :histories do |t|
      t.references :topic, null: false, foreign_key: true
      t.datetime :viewed_at, null: false
      t.boolean :understood, null: false, default: false

      t.timestamps
    end

    add_index :histories, :viewed_at
    add_index :histories, [:topic_id, :viewed_at]
  end
end

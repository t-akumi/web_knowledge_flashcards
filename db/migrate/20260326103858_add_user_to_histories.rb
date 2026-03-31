class AddUserToHistories < ActiveRecord::Migration[7.2]
  def change
    add_reference :histories, :user, null: false, foreign_key: true

    # 1ユーザーにつき 1テーマ 1履歴
    remove_index :histories, :topic_id if index_exists?(:histories, :topic_id)
    add_index :histories, [:user_id, :topic_id], unique: true
  end
end

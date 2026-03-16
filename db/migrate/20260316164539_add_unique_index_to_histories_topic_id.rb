class AddUniqueIndexToHistoriesTopicId < ActiveRecord::Migration[7.2]
  def change
    remove_index :histories, :topic_id if index_exists?(:histories, :topic_id)
    add_index :histories, :topic_id, unique: true
  end
end

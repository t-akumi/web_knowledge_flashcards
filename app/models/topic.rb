class Topic < ApplicationRecord
    
    has_many :history, dependent: :destroy

    TOPIC_TYPE_LABELS = {
        "concept" => "概念",
        "implementation" => "実装"
      }.freeze

      def topic_type_label
        TOPIC_TYPE_LABELS[topic_type] || topic_type
      end
end

class TopicCandidate < ApplicationRecord
    STATUSES = %w[pending approved rejected].freeze
    TYPES = %w[concept implementation].freeze
  
    validates :category, :title, :topic_type, :status, presence: true
    validates :status, inclusion: { in: STATUSES }
    validates :topic_type, inclusion: { in: TYPES }
end

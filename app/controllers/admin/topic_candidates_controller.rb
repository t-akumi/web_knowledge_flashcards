module Admin
  class TopicCandidatesController < BaseController
    def index
      @candidates = TopicCandidate.order(created_at: :desc).limit(200)
    end

    def generate
      # まずはダミー生成（後でAIに差し替える）
      created = TopicCandidateGenerator.generate!(category: "web_basics", count: 10)

      redirect_to admin_topic_candidates_path, notice: "候補を#{created}件生成しました"
    end

    def approve
      candidate = TopicCandidate.find(params[:id])

      Topic.transaction do
        Topic.find_or_create_by!(category: candidate.category, title: candidate.title) do |t|
          t.topic_type = candidate.topic_type
          t.status = "seeded"
        end
        candidate.update!(status: "approved")
      end

      redirect_to admin_topic_candidates_path, notice: "承認しました"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to admin_topic_candidates_path, alert: "承認に失敗: #{e.message}"
    end

    def reject
      candidate = TopicCandidate.find(params[:id])
      candidate.update!(status: "rejected")
      redirect_to admin_topic_candidates_path, notice: "却下しました"
    end
  end
end

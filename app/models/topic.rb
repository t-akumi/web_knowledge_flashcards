class Topic < ApplicationRecord
    
    has_many :history, dependent: :destroy

    TOPIC_TYPE_LABELS = {
        "concept" => "概念",
        "implementation" => "実装"
      }.freeze

      def topic_type_label
        TOPIC_TYPE_LABELS[topic_type] || topic_type
    end

    # 公式系のみ（必要なら増やす）
    OFFICIAL_REFERENCE_HOSTS = %w[
        developer.mozilla.org
        www.rfc-editor.org
        rfc-editor.org
        cheatsheetseries.owasp.org
        owasp.org
        www.w3.org
        whatwg.org
        developer.chrome.com
        web.dev
        learn.microsoft.com
    ].freeze

    DIFFICULTY_LABELS = {
        "beginner" => "初級",
        "intermediate" => "中級",
        "advanced" => "上級"
    }.freeze

    def difficulty_label
        DIFFICULTY_LABELS[difficulty] || difficulty
    end
      

    def official_references
        Array(references).filter_map do |url|
        begin
            uri = URI.parse(url.to_s.strip)
            next unless uri.is_a?(URI::HTTPS)
            next unless OFFICIAL_REFERENCE_HOSTS.include?(uri.host)
            uri.to_s
        rescue URI::InvalidURIError
            nil
        end
        end.uniq
    end
end

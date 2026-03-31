class TopicCandidateGenerator
    # ダミー
    # 後でここをAIに差し替える
    TITLES = [
      ["HTTP/1.1 と HTTP/2 の違い", "concept"],
      ["SameSite Cookie の基礎", "implementation"],
      ["CSP（Content Security Policy）入門", "implementation"],
      ["フォーム送信の基本（GET/POSTの違い）", "concept"],
      ["CSRFトークンが守っているもの", "implementation"],
      ["ETag と Last-Modified の使い分け", "implementation"],
      ["URLエンコードと文字化けの基礎", "concept"],
      ["JWTの落とし穴（保存場所と失効）", "implementation"],
      ["OAuthの認可コードフロー超概要", "concept"],
      ["Webhookの再送と冪等性", "implementation"],
      ["Rate Limit の基本戦略", "implementation"],
      ["ブラウザの同一生成元ポリシー", "concept"],
    ].freeze
  
    def self.generate!(category:, count:)
      created = 0
      existing_titles = Topic.pluck(:title).to_set
      existing_candidates = TopicCandidate.where(status: "pending").pluck(:title).to_set
  
      pool = TITLES.shuffle
  
      while created < count && pool.any?
        title, type = pool.pop
        next if existing_titles.include?(title)
        next if existing_candidates.include?(title)
       # 上記のnext ifは一致する場合、以下の処理をスキップする　　トピックモデルと候補モデルで一致するタイトルがあれば新しい候補として作成しない処理
        TopicCandidate.create!(
          category: category,
          title: title,
          topic_type: type,
          status: "pending"
        )
        created += 1
      end
  
      created
    end
end
  
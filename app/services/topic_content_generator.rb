# app/services/topic_content_generator.rb
class TopicContentGenerator
    def self.call(topic)
      return topic if topic.status == "generated"
  
      # MVPではダミー生成（次のステップでAIに差し替える）
      topic.summary = "【概要】#{topic.title} の基本を短時間で理解するための要点をまとめます。"
      topic.steps = steps_text_for(topic)
      topic.deep_dive = "【深掘り】よくある落とし穴、関連概念、実務での観点（安全性・パフォーマンス・運用）を簡単に整理します。"
      topic.references = default_references_for(topic)
      topic.status = "generated"
      topic.generated_at = Time.current
      topic.save!
      topic
    end
  
    def self.steps_text_for(topic)
      if topic.topic_type == "implementation"
        [
          "1. どのレイヤー（フロント/バック/インフラ）で発生する問題か整理する",
          "2. 最小構成で再現できるサンプルを作る",
          "3. 設定やヘッダー/パラメータの確認ポイントを列挙する",
          "4. 実装（または設定）を適用する",
          "5. 想定ケースで動作確認する",
          "6. セキュリティ/運用上の注意点をメモする",
        ].join("\n")
      else
        [
          "1. 用語の意味を整理する",
          "2. 具体例（ブラウザ↔サーバ）で流れを追う",
          "3. よくある誤解・落とし穴を確認する",
          "4. 関連概念（似た用語）との差を整理する",
          "5. 実務での観点（監視/安全性/性能）に触れる",
        ].join("\n")
      end
    end
  
    def self.default_references_for(topic)
      # MVPでは固定（次でテーマに応じて増やせる）
      [
        "https://developer.mozilla.org/",
        "https://www.rfc-editor.org/"
      ]
    end
  end
  
require "json"
require "set"

class TopicCandidateGenerator
  MODEL = "gpt-5-mini" # 安価なmini（後で変更可能）
  TYPES = %w[concept implementation].freeze

  def self.generate!(category:, count:, difficulty:)
    raise "OPENAI_API_KEY is missing" if ENV["OPENAI_API_KEY"].to_s.strip.empty?

    existing_titles = Topic.where(category: category).pluck(:title).to_set
    existing_candidates = TopicCandidate.where(category: category, status: "pending").pluck(:title).to_set

    banned = (existing_titles + existing_candidates).to_a

    schema = {
      type: "object",
      additionalProperties: false,
      properties: {
        candidates: {
          type: "array",
          minItems: count,
          maxItems: count,
          items: {
            type: "object",
            additionalProperties: false,
            properties: {
              title: { type: "string", minLength: 5, maxLength: 80 },
              topic_type: { type: "string", enum: TYPES }
            },
            required: %w[title topic_type]
          }
        }
      },
      required: ["candidates"]
    }

    messages = [
      {
        role: "system",
        content: <<~SYS
            あなたはWeb基礎の学習テーマを提案する編集者です。
            出力は必ず日本語で、タイトルも日本語のみ（英語のみは禁止）にしてください。
            既存のタイトル（BANNED）と重複・言い換えは絶対にしないでください。
            形式は指定されたJSON Schemaに厳密に従ってください。
        SYS
      },
      {
        role: "user",
        content: <<~USR
            カテゴリ: #{category}
            難易度: #{difficulty}（beginner/intermediate/advanced）
            #{count}件の新しいテーマ候補を作ってください。

            条件:
            - タイトルは日本語（英語だけのタイトルは禁止。必要なら括弧で英語補足はOK）
            - 5〜80文字程度
            - topic_type は concept または implementation
            - 既存のタイトル（BANNED）と重複・言い換えは禁止

            BANNED TITLES (must not repeat or paraphrase):
            #{banned.map { |t| "- #{t}" }.join("\n")}
        USR
      }
    ]

    resp = OpenaiClient.client.chat.completions.create(
      model: MODEL,
      messages: messages,
      # Structured Outputs (JSON Schema)
      response_format: {
        type: "json_schema",
        json_schema: {
          name: "topic_candidates",
          strict: true,
          schema: schema
        }
      }
    )
    # Ruby SDK: chat completion result structure
    content = resp.choices[0].message.content
    data = JSON.parse(content)

    created = 0
    data.fetch("candidates").each do |c|
      title = c.fetch("title").strip
      type = c.fetch("topic_type")

      next if existing_titles.include?(title)
      next if existing_candidates.include?(title)

      TopicCandidate.create!(
        category: category,
        title: title,
        topic_type: type,
        difficulty: difficulty,
        status: "pending"
      )
      created += 1
      break if created >= count
    end

    created
  rescue JSON::ParserError => e
    raise "AI response JSON parse failed: #{e.message}"
  end
end
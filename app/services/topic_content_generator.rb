require "json"

class TopicContentGenerator
  MODEL = "gpt-5-mini"

  def self.call(topic)
    return topic if topic.status == "generated"

    schema = {
      type: "object",
      additionalProperties: false,
      properties: {
        summary: { type: "string", minLength: 200, maxLength: 1200 },
        steps:  { type: "array", minItems: 5, maxItems: 12, items: { type: "string", minLength: 3, maxLength: 120 } },
        deep_dive: { type: "string", minLength: 300, maxLength: 2000 },
        references: {
          type: "array",
          minItems: 2,
          maxItems: 6,
          items: { type: "string", minLength: 10, maxLength: 200 }
        }
      },
      required: %w[summary steps deep_dive references]
    }

    messages = [
      {
        role: "system",
        content: <<~SYS
          You are an expert tutor for web development fundamentals.
          Create high-quality learning content in Japanese.
          Output must follow the provided JSON Schema strictly.
          Avoid hallucinating concrete product-specific claims. Prefer general, accurate explanations.
          For references, prefer MDN, RFC Editor, OWASP, W3C, WHATWG, and official vendor docs.
        SYS
      },
      {
        role: "user",
        content: <<~USR
          Topic title: #{topic.title}
          Topic type: #{topic.topic_type} (concept or implementation)

          Please generate:
          - summary: 400-600 Japanese characters
          - steps: 6-10 bullet-like steps (strings). If concept, steps should be "理解のステップ". If implementation, steps should be "実装/検証のステップ".
          - deep_dive: 600-900 Japanese characters (pitfalls, how it appears in real systems, security/performance notes)
          - references: 3-5 URLs (prefer official docs)

          IMPORTANT:
          - Do not repeat the title as-is in the summary.
          - Keep steps actionable and short.
        USR
      }
    ]

    resp = OpenaiClient.client.chat.completions.create(
      model: MODEL,
      messages: messages,
      response_format: {
        type: "json_schema",
        json_schema: {
          name: "topic_content",
          strict: true,
          schema: schema
        }
      }
    )

    content = resp.choices[0].message.content
    data = JSON.parse(content)

    topic.summary = data["summary"]
    topic.steps = data["steps"].join("\n")
    topic.deep_dive = data["deep_dive"]
    topic.references = filter_official_urls(data["references"])
    topic.status = "generated"
    topic.generated_at = Time.current
    topic.save!

    topic
  rescue => e
    # 失敗時は status を変えず、上位で表示できるように例外を投げる
    raise e
  end

  def self.filter_official_urls(urls)
    Array(urls).filter_map do |url|
      begin
        uri = URI.parse(url.to_s.strip)
        next unless uri.is_a?(URI::HTTPS)
        next unless Topic::OFFICIAL_REFERENCE_HOSTS.include?(uri.host)
        uri.to_s
      rescue URI::InvalidURIError
        nil
      end
    end.uniq
  end
  
end

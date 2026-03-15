# db/seeds.rb
topics = [
  ["HTTPとは（リクエスト/レスポンスの流れ）", "concept"],
  ["URLの構造（scheme/host/path/query/fragment）", "concept"],
  ["HTTPメソッド（GET/POST/PUT/PATCH/DELETE）", "concept"],
  ["ステータスコード（2xx/3xx/4xx/5xx）", "concept"],
  ["HTTPヘッダー入門（Content-Type/Accept/Authorization等）", "concept"],
  ["CookieとSessionの仕組み", "implementation"],
  ["ローカルストレージ / セッションストレージの違い", "implementation"],
  ["キャッシュの基礎（Cache-Control/ETag）", "implementation"],
  ["CORSとは何か（なぜ必要？どう直す？）", "implementation"],
  ["CSRFの基礎（仕組みと対策）", "implementation"],
  ["XSSの基礎（種類と対策）", "implementation"],
  ["HTTPS/TLSの概要（証明書・暗号化・信頼）", "concept"],
  ["DNSの概要（名前解決の流れ）", "concept"],
  ["REST API設計の基本（リソース/URI/冪等性）", "concept"],
  ["JSONの基礎（構造・設計の注意点）", "concept"],
  ["認証と認可の違い", "concept"],
  ["JWTの基本（使い所・落とし穴）", "implementation"],
  ["OAuth2の基本（ざっくりフロー理解）", "concept"],
  ["Webhookの基本（仕組みと安全な実装）", "implementation"],
  ["Rate Limit（なぜ必要？実装の考え方）", "implementation"],
]

topics.each do |title, topic_type|
  Topic.find_or_create_by!(category: "web_basics", title: title) do |t|
    t.topic_type = topic_type
    t.status = "seeded"
  end
end

puts "Seeded #{Topic.count} topics"

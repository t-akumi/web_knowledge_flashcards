require "openai"

class OpenaiClient
  def self.client
    @client ||= OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"])
  end
end

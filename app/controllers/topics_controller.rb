class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params[:id])

    # 未生成なら生成（MVPはダミー）
    TopicContentGenerator.call(@topic) if @topic.status != "generated"

    # 履歴を残す
    history = History.find_or_initialize_by(topic: @topic)
    history.viewed_at = Time.current
    history.save!
  end

  def understand
    topic = Topic.find(params[:id])
    history = History.find_or_initialize_by(topic: topic)
    history.viewed_at ||= Time.current
    history.understood = true
    history.save!
  
    redirect_to histories_path
  end
end

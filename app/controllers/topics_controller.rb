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

  def next
    current_id = params[:current_id].to_i
    requested_type = params[:type].presence
  
    scope = Topic.where(category: "web_basics")
    scope = scope.where.not(id: current_id) if current_id > 0
  
    # concept / implementation だけ許可（変な値は無視）
    if %w[concept implementation].include?(requested_type)
      scope = scope.where(topic_type: requested_type)
    end
  
    topic = scope.order(Arel.sql("RANDOM()")).first
  
    if topic
      redirect_to topic_path(topic)
    else
      # 条件に合うものがない場合は、タイプ無視で次を出す（or 元に戻す）
      fallback = Topic.where(category: "web_basics").where.not(id: current_id).order(Arel.sql("RANDOM()")).first
      redirect_to fallback ? topic_path(fallback) : topic_path(current_id)
    end
  end
  
end

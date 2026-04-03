class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params[:id])

    begin
      TopicContentGenerator.call(@topic) if @topic.status != "generated"
    rescue => e
      Rails.logger.error("Topic generation failed: #{e.class} #{e.message}")
      flash.now[:alert] = "内容の自動生成に失敗しました。時間を置いて再度お試しください。"
    end

    # 履歴を残す
    history = current_user.histories.find_or_initialize_by(topic: @topic)
    history.viewed_at = Time.current
    history.save!
  end

  def understand
    topic = Topic.find(params[:id])
    history = current_user.histories.find_or_initialize_by(topic: topic)
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

  def next_no_understood
    current_id = params[:current_id].to_i
  
    base = Topic.where(category: "web_basics")
    base = base.where.not(id: current_id) if current_id > 0
  
    # 履歴がある & understood=false のみ
    not_understood = base.joins(:histories)
    .where(histories: { user_id: current_user.id, understood: false })
  
    topic = not_understood.order(Arel.sql("RANDOM()")).first
  
    # 0件なら、履歴がある & understood=true（復習）
    if topic.nil?
      understood = base.joins(:histories)
        .where(histories: { user_id: current_user.id, understood: true })
      topic = understood.order(Arel.sql("RANDOM()")).first
    end
  
    redirect_to topic ? topic_path(topic) : root_path
  end
  

  def next_new
    current_id = params[:current_id].to_i
  
    base = Topic.where(category: "web_basics")
    base = base.where.not(id: current_id) if current_id > 0
  
    unseen = base.where.not(
      id: current_user.histories.select(:topic_id)
    )
  
    topic = unseen.order(Arel.sql("RANDOM()")).first
  
    if topic
      redirect_to topic_path(topic)
    else
      render :no_more_topics, status: :ok
    end
  end
  

end

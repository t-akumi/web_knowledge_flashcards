class TopicsController < ApplicationController
  def show
    @topic = Topic.find(params[:id])

    # 未生成なら生成（MVPはダミー）
    TopicContentGenerator.call(@topic) if @topic.status != "generated"

    # 履歴を残す（同日に何回見たか残してもOK。MVPは毎回記録でOK）
    History.create!(topic: @topic, viewed_at: Time.current)
  end

  def understand
    topic = Topic.find(params[:id])
    last = History.where(topic: topic).order(viewed_at: :desc).first

    if last
      last.update!(understood: true)
    else
      History.create!(topic: topic, viewed_at: Time.current, understood: true)
    end

    redirect_to histories_path
  end
end

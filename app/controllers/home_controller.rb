class HomeController < ApplicationController
  def show
    # Web基礎からランダムに1件
    @topic = Topic.where(category: "web_basics").order(Arel.sql("RANDOM()")).first
  end
end

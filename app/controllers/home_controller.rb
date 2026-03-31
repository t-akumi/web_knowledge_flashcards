class HomeController < ApplicationController
  def show
    # Web基礎からランダムに1件
    if user_signed_in?
      @topic = Topic.where(category: "web_basics").order(Arel.sql("RANDOM()")).first
    end
  end
end

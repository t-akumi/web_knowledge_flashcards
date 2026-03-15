class HistoriesController < ApplicationController
  def index
    @histories = History.includes(:topic).order(viewed_at: :desc).limit(200)
  end
end

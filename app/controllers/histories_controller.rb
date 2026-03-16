class HistoriesController < ApplicationController
  def index
    @histories = History.includes(:topic).order(viewed_at: :desc)
  end
end

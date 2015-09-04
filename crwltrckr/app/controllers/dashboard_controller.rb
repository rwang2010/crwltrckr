class DashboardController < ApplicationController
  def index
    @crawl_projects = CrawlProject.order(updated_at: :desc).limit(3)
  end
end

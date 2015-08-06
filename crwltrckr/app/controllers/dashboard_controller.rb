class DashboardController < ApplicationController
  def index
    @crawl_projects = CrawlProject.all.sample(3)
  end
end

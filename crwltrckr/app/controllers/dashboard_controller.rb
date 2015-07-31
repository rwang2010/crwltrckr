class DashboardController < ApplicationController
  def index
    @rosalyn = "hellodfaffsd"
    @crawl_projects = CrawlProject.all
  end
end

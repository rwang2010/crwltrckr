class CrawlProjectsController < ApplicationController

  def index
    @crawl_projects = CrawlProject.all
  end

  def show
    @crawl_project = CrawlProject.find(params[:id])
    @crawl_project.hosts.each do |host|
      host.refresh_stats
    end
    @stats_keys = %w(id name crawl_active extract_active recrawl_enabled active_host_patterns found cached queued failed last_cached last_extraction regression_tests)
  end

  def new
    @crawl_project = CrawlProject.new
  end

  def edit
    @crawl_project = CrawlProject.find(params[:id])
  end

  def create
    @crawl_project = CrawlProject.new(crawl_project_params)
   
    if @crawl_project.save
      redirect_to @crawl_project
    else
      render 'new'
    end
  end

  def update
    @crawl_project = CrawlProject.find(params[:id])
   
    if @crawl_project.update(crawl_project_params)
      redirect_to(:back)
    else
      render 'edit'
    end
  end

  def destroy
    @crawl_project = CrawlProject.find(params[:id])
    @crawl_project.destroy

    redirect_to crawl_project_path
  end

  private

  def crawl_project_params
    params.require(:crawl_project).permit(:name, :description, :host_name)
  end
end

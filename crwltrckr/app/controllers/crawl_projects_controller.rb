class CrawlProjectsController < ApplicationController

  def index
    @crawl_projects = CrawlProject.all
  end

  def show
    @crawl_project = CrawlProject.find(params[:id])
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
      redirect_to @crawl_project
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
    params.require(:crawl_project).permit(:name, :description)
  end
end

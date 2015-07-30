require_relative '20150730170009_add_hosts_to_crawl_projects'

class RemoveHostsFromCrawlProjects < ActiveRecord::Migration
  def change
    revert AddHostsToCrawlProjects
  end
end

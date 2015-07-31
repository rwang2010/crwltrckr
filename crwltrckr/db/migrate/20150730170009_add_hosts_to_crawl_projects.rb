class AddHostsToCrawlProjects < ActiveRecord::Migration
  def change
    add_column :crawl_projects, :host_ids, :text, default: [].to_yaml
  end
end

class AddHostsCrawlPatternsAssocation < ActiveRecord::Migration
  def change
    create_table :crawl_projects_hosts, id: false do |t|
      t.belongs_to :crawl_project, index: true
      t.belongs_to :host, index: true
    end
  end
end

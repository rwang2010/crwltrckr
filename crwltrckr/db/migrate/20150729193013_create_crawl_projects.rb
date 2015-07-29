class CreateCrawlProjects < ActiveRecord::Migration
  def change
    create_table :crawl_projects do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end

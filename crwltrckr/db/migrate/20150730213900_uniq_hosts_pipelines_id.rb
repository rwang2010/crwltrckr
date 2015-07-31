class UniqHostsPipelinesId < ActiveRecord::Migration
  def change
    add_index :hosts, :pipelines_id, unique: true
  end
end

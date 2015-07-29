class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.number :pipelines_id
      t.string :domain

      t.timestamps null: false
    end
  end
end

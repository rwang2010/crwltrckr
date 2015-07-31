class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.integer :pipelines_id
      t.string :domain
      t.

      t.timestamps null: false
    end
  end
end

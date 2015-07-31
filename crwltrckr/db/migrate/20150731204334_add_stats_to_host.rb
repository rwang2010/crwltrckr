class AddStatsToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :stats, :text, default: {}.to_yaml
    remove_column :hosts, :cached_ages, :text
    remove_column :hosts, :cached_ages_updated_at, :datetime
  end
end

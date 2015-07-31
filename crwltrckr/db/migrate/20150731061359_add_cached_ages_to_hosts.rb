class AddCachedAgesToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :cached_ages, :text, default: [].to_yaml
    add_column :hosts, :cached_ages_updated_at, :datetime
  end
end

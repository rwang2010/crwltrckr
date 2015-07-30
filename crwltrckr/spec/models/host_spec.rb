require 'rails_helper'

RSpec.describe Host, :type => :model do
  it 'has many associated crawl_projects' do
    h = Host.new(pipelines_id: 103)
    h.save!
    h.crawl_projects.create!(name: 'sharks')
  end

  describe '#lookup_host_id' do
    it 'gets a host_id for 4sq.com' do
      expect(Host.lookup_host_id("4sq.com")).to eq(239810)
    end
  end

  describe '#stats' do
    it 'gets stats from pipelines' do
      h = Host.new(pipelines_id: 103)
      expect(h.stats).to be_truthy
    end
  end
end

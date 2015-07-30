require 'rails_helper'

RSpec.describe CrawlProject, :type => :model do
  it 'looks up host ids from a host name' do
    cp = CrawlProject.create!(name: 'Sharks', description: 'All the websites with shark data')
    cp.update(host_name: '4sq.com')
    expect(cp.hosts.map {|h| h[:pipelines_id]}).to eq([239810])
  end

  it 'has many hosts associated with it' do
    cp = CrawlProject.create!(name: 'Sharks', description: 'All the websites with shark data')
    cp.hosts.create!(pipelines_id: 103)
    cp.hosts.create!(pipelines_id: 104)
    expect(cp.hosts.size).to eq(2)
  end

  it 'doesn\'t save duplicate hosts' do
    cp = CrawlProject.create!(name: 'Sharks', description: 'All the websites with shark data')
    cp.hosts.create(pipelines_id: 103)
    expect(cp.hosts.new(pipelines_id: 103).save).to be_falsey
  end
end

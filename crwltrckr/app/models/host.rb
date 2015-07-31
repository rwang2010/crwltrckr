class Host < ActiveRecord::Base
  validates :pipelines_id, presence: true
  validates :pipelines_id, uniqueness: true
  has_and_belongs_to_many :crawl_projects, -> { uniq }

  PIPELINES_HOST = "http://10.0.100.228:3000"

  def stats
    path = "/hosts/#{self.pipelines_id}/stats.json"
    self.class.get_json_from_pipelines(path)
  end

  def self.lookup_host_id(host_name)
    path = "/hosts/lookup?host=#{host_name}"
    self.get_json_from_pipelines(path)["host_id"].to_i
  end

  def self.get_json_from_pipelines(path)
    c = Curl::Easy.new(PIPELINES_HOST + path)
    c.perform
    JSON.parse(c.body_str)
  end

end

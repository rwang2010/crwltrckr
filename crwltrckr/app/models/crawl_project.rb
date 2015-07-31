class CrawlProject < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 5 }

  has_and_belongs_to_many :hosts, -> { uniq }

  before_validation :host_name_to_pipelines_id, if: :host_name

  def host_name_to_pipelines_id
    return if !@host_name
    pipelines_id = Host.lookup_host_id(@host_name)
    if pipelines_id == 0
      errors.add(:hosts, "couldn't find host matching #{@host_name}")
      return
    end
    host = Host.where(pipelines_id: pipelines_id).first
    if host
      self.hosts << host
    else
      self.hosts.create(pipelines_id: pipelines_id)
    end
  end

  def host_name
    @host_name
  end

  def host_name=(val)
    @host_name = val
  end

  def pipelines_ids
    self.hosts.map { |h| h.pipelines_id }
  end

end

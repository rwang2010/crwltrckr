class Host < ActiveRecord::Base
  validates :pipelines_id, presence: true
  validates :domain, presence: true
end

include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

class Host < ActiveRecord::Base
  validates :pipelines_id, presence: true
  validates :pipelines_id, uniqueness: true
  has_and_belongs_to_many :crawl_projects, -> { uniq }

  PIPELINES_HOST = "http://10.0.100.228:3000"

  def stats
    path = "/hosts/#{self.pipelines_id}/stats.json"
    stats = self.class.get_json_from_pipelines(path)
    %w(cached queued found failed).each do |key|
      stats[key] = format_number(stats[key].to_i)
    end
    stats['regression_tests'] = format_regression_tests(stats["regression_tests"])
    stats['last_cached'] = date_to_days_ago(stats["last_cached"])
    stats['last_extraction'] = date_to_days_ago(stats["last_extraction"])
    stats
  end

  def format_regression_tests(tests)
    "#{tests["passed"]} / #{tests.values.reduce(:+)}"
  end

  def date_to_days_ago(date_str)
    "#{time_ago_in_words(Date.parse(date_str))}" if date_str && Date.parse(date_str)
  end

  def format_number(num)
    number_to_human(num, { units: { thousand: "K", million: "MM" }, precision: 2})
  end

  def format_last_extraction(date_str)
    "#{time_ago_in_words(Date.parse(date_str))} ago"
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

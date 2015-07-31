include ActionView::Helpers::DateHelper
include ActionView::Helpers::NumberHelper

class Host < ActiveRecord::Base
  validates :pipelines_id, presence: true
  validates :pipelines_id, uniqueness: true
  serialize :stats, Hash
  has_and_belongs_to_many :crawl_projects

  PIPELINES_HOST = "http://10.0.100.228:3000"
#   PIPELINES_HOST = "http://10.0.100.210:3001"
  CACHED_AGES_UPDATE_INTERVAL = 15 #days 
  STATS_UPDATE_INTERVAL = 1 #days 

  def get_stats
    if self.stats['updated_at'] && self.stats['updated_at'] > Date.today - STATS_UPDATE_INTERVAL
      return self.stats
    end
    self.stats = get_stats_from_pipelines()
    self.stats['updated_at'] = Date.today
    self.save
    self.stats
  end

  def get_stats_from_pipelines
    path = "/hosts/#{self.pipelines_id}/stats.json"
    stats = self.class.get_json_from_pipelines(path)
    %w(cached queued found failed).each do |key|
      stats[key] = format_number(stats[key].to_i)
    end
    stats['regression_tests'] = format_regression_tests(stats["regression_tests"]) if stats["regression_tests"]
    stats['last_cached'] = date_to_days_ago(stats["last_cached"])
    stats['last_extraction'] = date_to_days_ago(stats["last_extraction"])
    stats['cached_ages'] = get_cached_ages
    stats
  end

  def get_cached_ages
    if self.stats['cached_ages_updated_at'] && self.stats['cached_ages_updated_at'] > Date.today - CACHED_AGES_UPDATE_INTERVAL
      return self.stats['cached_ages']
    end
    self.stats['cached_ages_updated_at'] = Date.today
    counts = []
    counts << input_age_count('cached', 91)
    counts << input_age_count('cached', 182, 91)
    counts << input_age_count('cached', 365, 182)
    counts << input_age_count('cached', 710, 365)
    counts << input_age_count('cached', 100000, 710)
    counts
  end

  def input_age_count(type='cached', days_ago_start=nil, days_ago_end=nil)
    path = "/hosts/#{self.pipelines_id}/urls/stats.json?type=#{type}"
    path += "&days_ago_start=#{days_ago_start}" if days_ago_start
    path += "&days_ago_end=#{days_ago_end}" if days_ago_end
    count = self.class.get_json_from_pipelines(path)['count']
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

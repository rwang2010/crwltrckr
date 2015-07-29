class Todo < ActiveRecord::Base
  validates :text, presence: true
end

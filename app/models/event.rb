class Event < ActiveRecord::Base
  belongs_to :source, validate: true

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :title, presence: true
  validates :url, presence: true
end

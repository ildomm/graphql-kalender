class Source < ActiveRecord::Base
  has_many :events, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }
  validates :url, presence: true, uniqueness: true, length: { minimum: 3 }
end

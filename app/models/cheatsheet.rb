class Cheatsheet < ApplicationRecord
  belongs_to :user
  before_save { self.topic = topic.downcase }

  validates :title, presence: true, length: { maximum: 1000 }
  validates :topic, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :user_id, presence: true
end

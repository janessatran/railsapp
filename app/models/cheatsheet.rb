class Cheatsheet < ApplicationRecord
  belongs_to :user
  # before_save { self.topic = topic.downcase }
  acts_as_taggable

  validates :title, presence: true, length: { maximum: 1000 }
  validates :tag_list, presence: true
  validates :content, presence: true
  validates :user_id, presence: true
end

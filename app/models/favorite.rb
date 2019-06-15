class Favorite < ApplicationRecord
  belongs_to :cheatsheet
  belongs_to :user
end

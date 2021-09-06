class Version < ApplicationRecord
  belongs_to :exercise
  belongs_to :user
  validates :exercise, presence: true
end

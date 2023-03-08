class GoalLabel < ApplicationRecord
  validates :label, presence: true, uniqueness: true
end

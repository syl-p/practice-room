class Medium < ApplicationRecord
    has_many :media_exercises
    has_many :exercises, through: :media_exercises
    belongs_to :user
    # validates :name, presence: true
    has_one_attached :file
end

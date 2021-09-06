class Medium < ApplicationRecord
    has_many :media_exercises
    has_many :exercises, through: :media_exercises

    include MediumUploader::Attachment(:file)
    validates :name, presence: true
end

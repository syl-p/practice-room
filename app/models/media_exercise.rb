class MediaExercise < ApplicationRecord
    self.table_name = "media_exercises"

    belongs_to :exercise
    belongs_to :medium
end

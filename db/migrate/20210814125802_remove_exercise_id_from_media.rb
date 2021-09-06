class RemoveExerciseIdFromMedia < ActiveRecord::Migration[6.0]
  def change
    remove_column :media, :exercise_id
  end
end

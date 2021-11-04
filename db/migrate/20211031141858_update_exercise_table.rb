class UpdateExerciseTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :exercises, :exercise, foreign_key: true
    add_column :exercises, :published, :boolean, default: true
  end
end

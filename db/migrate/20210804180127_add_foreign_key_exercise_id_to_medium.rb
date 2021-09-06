class AddForeignKeyExerciseIdToMedium < ActiveRecord::Migration[6.0]
  def change
    add_reference :media, :exercise, foreign_key: true
  end
end

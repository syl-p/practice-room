class CreateMediaExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :media_exercises do |t|
      t.integer 10_id
      t.integer :exercise_id
    end

    add_index :media_exercises, %I(medium_id exercise_id), name: :media_exercise
  end
end

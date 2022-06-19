class CreatePracticesExercises < ActiveRecord::Migration[7.0]
  def change
    create_table :practices_exercises do |t|
      t.belongs_to :practice, null: false, foreign_key: true
      t.belongs_to :exercise, null: false, foreign_key: true
      t.integer :duration, null: false
      t.timestamps
    end
  end
end

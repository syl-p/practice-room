class AddTimestampToMediaExercises < ActiveRecord::Migration[7.0]
  def change
    add_column :media_exercises, :created_at, :timestamp
  end
end

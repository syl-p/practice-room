class AddLevelAndDurationToExercise < ActiveRecord::Migration[7.0]
  def change
    add_column :exercises, :level, :integer
    add_column :exercises, :duration, :integer, default: 600
  end
end

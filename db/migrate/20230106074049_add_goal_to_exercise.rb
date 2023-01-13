class AddGoalToExercise < ActiveRecord::Migration[7.0]
  create_table :goal_labels do |t|
    t.string :label
  end

  def change
    add_column :exercises, :goal_end, :float
    add_column :exercises, :goal_start, :float
    add_reference :exercises, :goal_label
  end

  create_table :goal_settings do |t|
    t.belongs_to :exercise
    t.belongs_to :user
    t.float :value
    t.timestamps
  end

  add_index :goal_settings, [:exercise_id, :user_id], unique: true
end

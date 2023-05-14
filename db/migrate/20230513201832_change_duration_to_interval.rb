class ChangeDurationToInterval < ActiveRecord::Migration[7.0]
  def change
    change_column :exercises, :duration, :interval, using: "duration * INTERVAL '1 second'", default: "00:00:00"
    change_column :practices_exercises, :duration, :interval, using: "duration * INTERVAL '1 second'", default: "00:00:00"
  end
end

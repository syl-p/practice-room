class ChangeDurationToInterval < ActiveRecord::Migration[7.0]
  def change
    change_column :exercises, :duration, :interval, using: "duration * INTERVAL '1 second'", default: nil
    change_column_default :exercises, :duration, "00:00:00" # spécifiez une nouvelle valeur par défaut compatible avec le type "interval"
    change_column :practices_exercises, :duration, :interval, using: "duration * INTERVAL '1 second'", default: nil
    change_column_default :practices_exercises, :duration, "00:00:00"
  end
end

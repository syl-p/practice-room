class AddVersionsEnabledToExercises < ActiveRecord::Migration[7.0]
  def change
    add_column :exercises, :versions_enabled, :boolean, default: true
  end
end

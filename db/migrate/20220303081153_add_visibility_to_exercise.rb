class AddVisibilityToExercise < ActiveRecord::Migration[7.0]
  def change
    add_column :exercises, :visibility, :integer, default: 0
  end
end

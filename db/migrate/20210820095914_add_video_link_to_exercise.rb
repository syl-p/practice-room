class AddVideoLinkToExercise < ActiveRecord::Migration[6.0]
  def change
    add_column :exercises, :video_link, :text
  end
end

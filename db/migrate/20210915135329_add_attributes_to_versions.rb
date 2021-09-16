class AddAttributesToVersions < ActiveRecord::Migration[6.0]
  def change
    add_column :versions, :published, :boolean, default: false
    add_column :exercises, :published, :boolean, default: false
    add_column :versions, :video_link, :string
  end
end

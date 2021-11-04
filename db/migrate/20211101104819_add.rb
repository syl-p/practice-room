class Add < ActiveRecord::Migration[6.0]
  def change
    add_column :exercises, :description, :text
  end
end

class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :categories_exercises do |t|
      t.belongs_to :category
      t.belongs_to :exercise
      t.timestamps
    end
  end
end

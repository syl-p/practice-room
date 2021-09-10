class AddSessionsOfTheDaysColumn < ActiveRecord::Migration[6.0]
  create_table :sessions_of_the_days do |t|
    t.belongs_to :user, null: false, foreign_key: true
    t.json :sessions, array: true, default: [] # [{time: "11:00", exercises: [1, 2, 3]}, {...}, ...]
    t.timestamps
  end
  
end

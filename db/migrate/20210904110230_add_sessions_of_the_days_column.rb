class AddSessionsOfTheDaysColumn < ActiveRecord::Migration[6.0]
  create_table :session_of_the_days do |t|
    t.belongs_to :user, null: false, foreign_key: true
    t.date :date
    t.json :sessions, array: true, default: []
    t.timestamps
  end
  
end

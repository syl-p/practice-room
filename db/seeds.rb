# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

default_categories = [
  {name: "Jazz skills", description: "", slug: "jazz-skills"},
  {name: "Rythme et groove", description: "", slug: "rythme-et-groove"},
  {name: "Freatboard", description: "", slug: "freatboard"}
]

default_categories.each do |category|
  Category.create(name: category[:name],
                  description: category[:description],
                  slug: category[:slug])

end

default_goal_label = %w(bpm minutes pages pourcent)

default_goal_label.each do |goal_label|
  GoalLabel.create(label: goal_label)
end

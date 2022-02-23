class Friendship < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.references :requestor, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.boolean :accepted, default: false

      t.timestamps
    end

    add_index :friendships, [:requestor_id, :receiver_id], unique: true
  end
end

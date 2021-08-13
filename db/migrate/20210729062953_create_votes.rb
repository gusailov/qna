class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer  :value, null: false
      t.belongs_to :user, foreign_key: true
      t.references :votable, polymorphic: true
      t.index %i[user_id votable_id votable_type], unique: true

      t.timestamps
    end
  end
end

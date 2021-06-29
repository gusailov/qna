class AddFavoriteToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :favorite, :boolean, default: false, null: false
  end
end

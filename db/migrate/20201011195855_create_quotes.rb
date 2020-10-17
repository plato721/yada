class CreateQuotes < ActiveRecord::Migration[6.0]
  def change
    create_table :quotes do |t|
      t.string :body
      t.references :episode, foreign_key: true
      t.references :character, foreign_key: true
      t.references :season, foreign_key: true

      t.timestamps
    end
  end
end

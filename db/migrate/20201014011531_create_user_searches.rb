class CreateUserSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :user_searches do |t|
      t.references :user, null: false, foreign_key: true
      t.references :search, null: false, foreign_key: true

      t.timestamps
    end
  end
end

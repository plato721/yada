class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.text :criteria

      t.timestamps
    end
    add_index :searches, :criteria, unique: true
  end
end

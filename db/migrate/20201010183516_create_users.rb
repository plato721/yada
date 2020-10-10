class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.text :token
      t.text :email

      t.timestamps
    end
    add_index :users, :token, unique: true
    add_index :users, :email, unique: true
  end
end

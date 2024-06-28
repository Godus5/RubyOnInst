class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :nickname, null: false
      t.text :bio
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

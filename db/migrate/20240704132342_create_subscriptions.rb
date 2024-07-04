class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :follower, null: false, foreign_key: {to_table: :users}
      t.references :user, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end

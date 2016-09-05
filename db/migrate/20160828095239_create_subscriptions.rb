class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :subscribable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end

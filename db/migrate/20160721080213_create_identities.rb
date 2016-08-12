class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid

      t.index [:provider, :uid], unique: true

      t.timestamps null: false
    end
  end

end

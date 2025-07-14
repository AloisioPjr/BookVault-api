class CreateJwtAllowlists < ActiveRecord::Migration[8.0]
  def change
    create_table :jwt_allowlists do |t|
      t.string :jti
      t.datetime :exp
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :jwt_allowlists, :jti
  end
end

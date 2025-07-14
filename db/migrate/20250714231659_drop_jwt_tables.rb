class DropJwtTables < ActiveRecord::Migration[8.0]
  def change
    # Drop the JWT allowlist table
    drop_table :jwt_allowlists do |t|
      t.string :jti
      t.datetime :exp
      t.bigint :user_id, null: false
      t.timestamps
    end

    # Drop the JWT denylists table
    drop_table :jwt_denylists do |t|
      t.string :jti
      t.datetime :exp
      t.timestamps
    end
  end
end

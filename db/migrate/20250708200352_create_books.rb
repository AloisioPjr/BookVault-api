class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.string :genre
      t.integer :copies_available

      t.timestamps
    end
  end
end

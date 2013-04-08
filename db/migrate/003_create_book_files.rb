class CreateBookFiles < ActiveRecord::Migration
  def change
    create_table :book_files do |t|
      t.references :book
      t.string :file
    end
  end
end

class CreateBookRecords < ActiveRecord::Migration
  def change
    create_table :book_records do |t|
      t.references :book
      t.references :user
      t.date :taken_at
      t.date :returned_at
    end
  end
end

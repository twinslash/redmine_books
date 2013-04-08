class AddCurrentBookIdToBookRecords < ActiveRecord::Migration
  def self.up
    add_column :book_records, :current_book_id, :integer, default: nil
  end

  def self.down
    remove_column :book_records, :current_book_id
  end
end

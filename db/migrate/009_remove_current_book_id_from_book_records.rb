class RemoveCurrentBookIdFromBookRecords < ActiveRecord::Migration
  def self.up
    remove_column :book_records, :current_book_id
  end

  def self.down
    add_column :book_records, :current_book_id, :integer, default: nil
  end
end

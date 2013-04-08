class AddReturnedByToBookRecords < ActiveRecord::Migration
  def self.up
    add_column :book_records, :returned_by_id, :integer, default: nil
  end

  def self.down
    remove_column :book_records, :returned_by_id
  end
end

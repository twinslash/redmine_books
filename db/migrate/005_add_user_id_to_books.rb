class AddUserIdToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :user_id, :integer, default: nil
  end

  def self.down
    remove_column :books, :user_id
  end
end

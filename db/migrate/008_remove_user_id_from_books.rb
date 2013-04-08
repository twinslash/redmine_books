class RemoveUserIdFromBooks < ActiveRecord::Migration
  def self.up
    remove_column :books, :user_id
  end

  def self.down
    add_column :books, :user_id, :integer, default: nil
  end
end

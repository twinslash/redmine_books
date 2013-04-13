class AddOwnerIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :owner_id, :integer, :default => nil
    execute <<-SQL
      UPDATE books
      SET owner_id = NULL
    SQL
  end
end

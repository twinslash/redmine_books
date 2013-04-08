class AddTagNamesToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :tag_names, :string, default: ""
    # update old records
    execute <<-SQL
      UPDATE books
      SET books.tag_names = ""
    SQL
  end

  def down
    remove_column :books, :tag_names
  end
end

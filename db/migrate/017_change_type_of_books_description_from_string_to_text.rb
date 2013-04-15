class ChangeTypeOfBooksDescriptionFromStringToText < ActiveRecord::Migration
  def self.up
    add_column :books, :mock_description, :text
    execute <<-SQL
      UPDATE books
      SET mock_description = description
    SQL
    remove_column :books, :description
    rename_column :books, :mock_description, :description
  end

  def self.down
    rename_column :books, :description, :mock_description
    add_column :books, :description, :string
    execute <<-SQL
      UPDATE books
      SET description = mock_description
    SQL
    remove_column :books, :mock_description
  end
end

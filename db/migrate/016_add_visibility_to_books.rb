class AddVisibilityToBooks < ActiveRecord::Migration
  def change
    add_column :books, :visibility, :boolean, default: true
    execute <<-SQL
      UPDATE books
      SET visibility = true
    SQL
  end
end

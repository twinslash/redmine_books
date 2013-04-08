class AddRatingAverageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :rating_average, :float, :default => 0

    execute <<-SQL
      UPDATE books
      SET rating_average = 0
    SQL
  end
end

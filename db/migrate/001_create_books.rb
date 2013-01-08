class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :author
      t.string :description
      t.string :status
      t.string :title
    end
  end
end

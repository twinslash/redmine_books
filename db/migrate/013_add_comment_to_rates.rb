class AddCommentToRates < ActiveRecord::Migration
  def self.up
    add_column :rates, :comment, :text, :default => ""
  end

  def self.down
    remove_column :rates, :comment
  end
end

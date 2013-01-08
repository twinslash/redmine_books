class BookRecord < ActiveRecord::Base
  belongs_to :book
  belongs_to :user
  def self.last_by_taken_at
    order("taken_at DESC").first
  end
end

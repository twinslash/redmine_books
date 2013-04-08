class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true
  validates :comment, :length => { :minimum => 10 }

  attr_accessible :rate, :dimension, :comment
end

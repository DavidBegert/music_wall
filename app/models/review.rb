class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :song

  validates :post, :rating, presence: true


end
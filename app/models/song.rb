class Song < ActiveRecord::Base
  has_many :votes
  belongs_to :user

  validates :title, :artist, presence: true
  validate :cant_be_same_song



  def cant_be_same_song
    errors.add(:base, 'This song already exists') if Song.where(title: title, artist: artist).any?
  end
end
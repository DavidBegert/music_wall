class User < ActiveRecord::Base
  has_many :votes
  has_many :songs
  has_many :reviews

  validates :email, uniqueness: true

  def self.authenticate(params)
    User.find_by(username: params[:username], password: Digest::SHA1.hexdigest(params[:password]))
  end

  def has_already_reviewed?(song)
    reviews.any? {|review| review.song_id == song.id}
  end

  def has_already_voted?(song)
    votes.any? {|vote| vote.song_id == song.id}
  end

end
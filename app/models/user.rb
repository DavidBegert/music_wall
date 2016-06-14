class User < ActiveRecord::Base
  has_many :votes
  has_many :songs

  validates :email, uniqueness: true

  def self.authenticate(params)
    User.find_by(username: params[:username], password: Digest::SHA1.hexdigest(params[:password]))
  end

end
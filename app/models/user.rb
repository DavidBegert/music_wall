class User < ActiveRecord::Base
  has_many :votes

  validates :email, uniqueness: true

  def self.authenticate(params)
    User.find_by(username: params[:username], password: params[:password])
  end

end
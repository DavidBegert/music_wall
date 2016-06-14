class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :song

  validate :cannot_be_same_user_and_song_pair

  def cannot_be_same_user_and_song_pair
    errors.add(:base, 'You cannot vote for the same song twice') if Vote.where(user_id: user_id, song_id: song_id).any?
  end


end
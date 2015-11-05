class Tweet < ActiveRecord::Base
  validates :twitterid, presence: true, length: { maximum: 15 }
  validates :tweetdate, presence: true
end

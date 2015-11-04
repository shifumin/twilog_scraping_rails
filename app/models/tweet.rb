class Tweet < ActiveRecord::Base
  validates :twitterid, presence: true, length: { maximum: 50 }
  validates :tweetdate, presence: true
end

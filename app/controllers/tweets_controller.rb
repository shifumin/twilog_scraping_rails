class TweetsController < ApplicationController
  def home
    @tweet = Tweet.new
  end

  def view
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = Tweet.new(tweet_params)
    if @tweet.save
      redirect_to @tweet
    else
      render 'home'
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:twitterid, :tweetdate, :reply)
  end
end

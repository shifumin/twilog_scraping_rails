require 'open-uri'

class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :create]

  def new
    @tweet = Tweet.new
  end

  def show
    twitterid = @tweet.twitterid
    year = @tweet.tweetdate.year
    month = @tweet.tweetdate.month
    day = @tweet.tweetdate.day
    # reply = @tweet.reply

    @output_hash = get_tweet_data(twitterid, year, month, day)
  end

  def create
    if @tweet.save
      redirect_to tweets_show_path(@tweet)
    else
      render 'new'
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:twitterid, :tweetdate, :reply)
  end

  def set_tweet
    @tweet = Tweet.new(tweet_params)
  end

  # Twilogからツイートデータをスクレイピングするメソッド
  def get_tweet_data(twitterid, year, month, day)
    base_url = "http://twilog.org"

    # 2015年4月なら1504を代入したい
    year_month = "#{year - 2000}" + format("%02d", month)

    # URLの関係上、日付が1桁の場合も2桁に修正する e.g. 5(日) => "05"
    day = format("%02d", day)

    url = "#{base_url}/#{twitterid}/date-#{year_month}#{day}"
    doc = get_nokogiri_doc(url)

    # 指定されたTwitterIDがTwilogに登録されてあれば、ツイートを表示
    # 登録されていなければ、その旨を表示する
    if register_twilog?(doc)
      output_hash = {}
      tweets = []

      output_hash[:date] = doc.xpath("//div[@id='content']/h3/a[1]").text
      output_hash[:count] = doc.xpath("//div[@id='content']/h3/span").text
      doc.xpath("//article[@class='tl-tweet']/p[@class='tl-text']").each do |node|
        tweets << node.text
      end
      output_hash[:tweets] = tweets

      output_hash

    else
      render text: '指定されたTwitterIDはTwilogに登録されていません。'
    end
  end

  # URLからHTMLをパースしてオブジェクトを返すメソッド
  def get_nokogiri_doc(url)
    # UserAgentをIEに設定
    user_agent = "Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; rv:11.0)"

    begin
      html = open(url, "User-Agent" => user_agent)
    rescue OpenURI::HTTPError
      return
    end
    Nokogiri::HTML(html.read, nil, 'UTF-8')
  end

  # 指定TwitterIDがTwilogに登録されてあるかを調べるメソッド
  def register_twilog?(doc)
    doc.xpath("//p[@class='box-title']").text != "ユーザーが見つかりませんでした"
  end

  # その日にツイートがあるかどうかを調べるメソッド
  def has_tweet_texts?(doc)
    !doc.xpath("//div[@id='content']/h3").empty?
  end
end

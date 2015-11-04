class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :twitterid
      t.date :tweetdate
      t.boolean :reply

      t.timestamps null: false
    end
  end
end

//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Mina Kim on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    var liked : Bool = false
    var retweeted : Bool = false
    var tweetId : Int = -1

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitternameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = 35
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Code for retweeting a tweet
    func setRetweeted(_ isRetweeted: Bool){
        retweeted = isRetweeted
        if (retweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    @IBAction func didTapRetweet(_ sender: Any) {
        let retweetedTweet = !retweeted
        if (retweetedTweet){
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(true)
                //Adds to count label
                let retweets = Int(self.retweetsCountLabel.text as! String)! + 1
                self.retweetsCountLabel.text = String(retweets)
            }, failure: { (Error) in
                print("Falied to retweet: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
                self.setRetweeted(false)
                //Subtracts from count label
                let retweets = Int(self.retweetsCountLabel.text as! String)! - 1
                self.retweetsCountLabel.text = String(retweets)
            }, failure: { (Error) in
                print("Falied to retweet: \(Error)")
            })
        }
    }
    
    //Code for liking a tweet
    func setLiked(_ isLiked: Bool){
        liked = isLiked
        if (liked){
            likeButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        } else {
            likeButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    @IBAction func didTapLike(_ sender: Any) {
        let likedTweet = !liked
        if (likedTweet){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setLiked(true)
                //Adds to count label
                let likes = Int(self.likesCountLabel.text as! String)! + 1
                self.likesCountLabel.text = String(likes)
            }, failure: { (Error) in
                print("Failed to like a tweet \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setLiked(false)
                //Subtracts from count label
                let likes = Int(self.likesCountLabel.text as! String)! - 1
                self.likesCountLabel.text = String(likes)
            }, failure: { (Error) in
                print("Failed to un-like a tweet \(Error)")
            })
        }
    }
    
}

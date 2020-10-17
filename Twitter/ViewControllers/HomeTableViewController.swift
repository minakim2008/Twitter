//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Mina Kim on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetsArray = [NSDictionary]()
    var numOfTweets : Int!
    
    var refreshContoller = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        
        //Another way to refresh
        refreshContoller.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = refreshContoller

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("View did appear")
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        print("Loading tweets")
        numOfTweets = 15
        let twitterHomeUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": numOfTweets]
        
        //Calls Twitter API
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterHomeUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweetsArray.removeAll()
            for tweet in tweets{
                self.tweetsArray.append(tweet)
            }
            
            //Reloads tableView
            self.tableView.reloadData()
            //Ends refresh symbol
            self.refreshContoller.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetsArray.count{
            loadMoreTweets()
        }
    }
    
    func loadMoreTweets(){
        let twitterHomeUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets += 15
        let params = ["count": numOfTweets]
        
        //Calls Twitter API
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterHomeUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            
            self.tweetsArray.removeAll()
            for tweet in tweets{
                self.tweetsArray.append(tweet)
            }
            
            //Reloads tableView
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        //Goes back to login screen
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.setValue(false, forKey: "loggedIn")
        print("loggedIn: \(UserDefaults.standard.value(forKey: "loggedIn"))")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetsArray[indexPath.row]
        
        //Sets like and tweet counts for tweets
        var likes_set : (Int, Int) = (tweet["favorite_count"] as! Int).quotientAndRemainder(dividingBy: 1000)
        var retweets_set : (Int, Int) = (tweet["retweet_count"] as! Int).quotientAndRemainder(dividingBy: 1000)
        
        //Likes count label
        if (likes_set.0 > 0){
            cell.likesCountLabel.text = String(likes_set.0) + "." + String(likes_set.1).prefix(1) + "K"
        } else {
            cell.likesCountLabel.text = String(likes_set.1)
        }
        //Retweets count label
        if (retweets_set.0 > 0){
            cell.retweetsCountLabel.text = String(retweets_set.0) + "." + String(retweets_set.1).prefix(1) + "K"
        } else {
            cell.retweetsCountLabel.text = String(retweets_set.1)
        }
        
        //let likes = tweet["favorite_count"] as! Int
        //let retweets = tweet["retweet_count"] as! Int
        
        //cell.likesCountLabel.text = String(likes)
        //cell.retweetsCountLabel.text = String(retweets)
        
        //Sets username and tweet
        let user = tweet["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as! String
        cell.twitternameLabel.text = "@" + (user["screen_name"] as! String)
        cell.tweetLabel.text = tweet["text"] as! String
        
        //Sets profile picture
        let imageUrl = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data{
            cell.userImage.image = UIImage(data: imageData)
        }
        
        //Sends tweet id, sets liked button color, sends retweeted status
        cell.tweetId = tweetsArray[indexPath.row]["id"] as! Int
        cell.setLiked(tweetsArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweeted(tweetsArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        
        //Another way to refresh
        refreshContoller.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = refreshContoller

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func loadTweets(){
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
        UserDefaults.standard.setValue(false, forKey: "logginIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetsArray[indexPath.row]
        //Not sending tweet?
        cell.tweet = tweet
        
        //Can put all this in TweetCell?
        let user = tweet["user"] as! NSDictionary
        cell.usernameLabel.text = user["name"] as! String
        cell.tweetLabel.text = tweet["text"] as! String
        
        let imageUrl = URL(string: user["profile_image_url_https"] as! String)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.userImage.image = UIImage(data: imageData)
        }
        
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

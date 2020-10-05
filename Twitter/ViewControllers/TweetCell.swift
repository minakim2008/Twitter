//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Mina Kim on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    var tweet : NSDictionary = [:]

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = 30
        
        print(tweet)
        
//        let user = tweet["user"] as! NSDictionary
//        usernameLabel.text = user["name"] as! String
//        tweetLabel.text = tweet["text"] as! String
//
//        let imageUrl = URL(string: user["profile_image_url_https"] as! String)
//        let data = try? Data(contentsOf: imageUrl!)
//
//        if let imageData = data{
//            userImage.image = UIImage(data: imageData)
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

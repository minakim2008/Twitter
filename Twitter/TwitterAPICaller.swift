//
//  APIManager.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {    
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "uFTmFW66AAMEUwx3rZlZDMSCf", consumerSecret: "LtlxIoQpBvHcqjpSMIA9Gs2E9wCJbr7xkx9EpSdBYoNedaZUgh")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        TwitterAPICaller.client?.deauthorize()
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
            UIApplication.shared.open(url)
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    func logout (){
        deauthorize()
    }
    
    func getDictionaryRequest(url: String, parameters: [String:Any], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! NSDictionary)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getDictionariesRequest(url: String, parameters: [String:Any], success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()){
        print(parameters)
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func postRequest(url: String, parameters: [Any], success: @escaping () -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    //Posts tweet from twitter account
    func postTweet(tweetString : String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let urlString = "https://api.twitter.com/1.1/statuses/update.json"
        TwitterAPICaller.client?.post(urlString, parameters: ["status": tweetString], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error : Error) in
            print("Failed to call post tweet API: \(error)")
        })
    }
    
    //Sets tweet as "liked"
    func favoriteTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let urlString = "https://api.twitter.com/1.1/favorites/create.json?id=\(tweetId)"
        TwitterAPICaller.client?.post(urlString, parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("Liked tweet")
        }, failure: { (_: URLSessionDataTask?, error : Error) in
            print("Failed to call create favorites API: \(error)")
        })
    }
    //Sets tweet as neutral, i.e. "not liked"
    func unfavoriteTweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let urlString = "https://api.twitter.com/1.1/favorites/destroy.json?id=\(tweetId)"
        TwitterAPICaller.client?.post(urlString, parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("Unliked tweet")
        }, failure: { (_: URLSessionDataTask?, error : Error) in
            print("Failed to call destroy favorites API: \(error)")
        })
    }
    
    //Retweets a tweet
    func retweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let urlString = "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
        TwitterAPICaller.client?.post(urlString, parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error : Error) in
            print("Failed to call retweets API: \(error)")
        })
    }
    //Undoes a retweet
    func unretweet(tweetId: Int, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let urlString = "https://api.twitter.com/1.1/statuses/unretweet/\(tweetId).json"
        TwitterAPICaller.client?.post(urlString, parameters: ["id": tweetId], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (_: URLSessionDataTask?, error : Error) in
            print("Failed to call unretweets API: \(error)")
        })
    }
}

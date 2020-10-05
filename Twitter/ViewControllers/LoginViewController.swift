//
//  LoginViewController.swift
//  Twitter
//
//  Created by Mina Kim on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
        //Automatically opens Home screen?
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let twitterUrl = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: twitterUrl, success: {
            UserDefaults.standard.setValue(true, forKey: "loggedIn")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }, failure: { (Error) in
            print("Could not login")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

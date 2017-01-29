//
//  LoginViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/12/13.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, LoginButtonDelegate {
    let userDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
       if AccessToken.current != nil {
            fetchProfile()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
       
    }

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Did complete login via LoginButton with result \(result)")
        fetchProfile()
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logout")
        
        self.userDefaults.removeObject(forKey: "id")
        self.userDefaults.removeObject(forKey: "name")
        self.userDefaults.removeObject(forKey: "picture")
        self.userDefaults.synchronize()
        
    }
    
    func fetchProfile() {
        print("fetch profile")
        let connection = GraphRequestConnection()
        connection.add(FBProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                
                let pictDict =  response.dictionaryValue?["picture"] as? NSDictionary
                let pictureUrl = pictDict?["data"] as? NSDictionary
                let url = pictureUrl?["url"]
                
                self.userDefaults.set(response.dictionaryValue?["name"], forKey: "name")
                self.userDefaults.set(response.dictionaryValue?["id"], forKey: "id")
                self.userDefaults.set(url!, forKey: "picture")
               
                self.userDefaults.synchronize()

            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}

struct FBProfileRequest: GraphRequestProtocol {
    typealias Response = GraphResponse
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name,picture"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = 2.7
}

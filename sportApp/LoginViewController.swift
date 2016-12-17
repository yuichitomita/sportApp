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

class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func pushBackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
       
    }

    @IBAction func pushSnsButton(_ sender: Any) {
        let loginManeger = LoginManager()
        loginManeger.logIn([.publicProfile], viewController: self){ loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User canselled login.")
            case .success(let grantedPermissions, let declinedPermissions, let AccessToken):
                print("logged in")
            }
            
        }
    }
}

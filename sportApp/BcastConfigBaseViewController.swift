//
//  BcastConfigBaseViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/11/27.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class BcastConfigBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func dispAlert(_ sender: AnyObject) {
        let alert = UIAlertController(title: "放送開始", message: "放送開始してもいいですか?", preferredStyle: UIAlertControllerStyle.alert)
        let defaultAvtion = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) -> Void in
            let next = LiveViewController()
            
            self.navigationController?.pushViewController(next, animated: true)
        
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAvtion)
        
    
        self.present(alert, animated: true, completion: nil)
        
    }
}

//
//  ViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/04/09.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class TopViewController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        self.view.backgroundColor = UIColor.green
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


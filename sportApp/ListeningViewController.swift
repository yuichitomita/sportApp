//
//  ListeningViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/08/16.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class ListeningViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var atButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 背景画像
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "sunset")?.draw(in: self.view.bounds)
        
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comment")
        //cell?.imageView?.image = UIImage(named: "megane")
        cell?.imageView?.layer.cornerRadius = (cell?.imageView?.frame.size.width)! * 0.5;
        //cell?.imageView?.clipsToBounds = true
        
        return cell!
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    @IBAction func OpenButtonTouchUpInside(sender: UIButton) {
        atButton = sender 
        
        let modalViewController = ProgramInfoModalViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        present(modalViewController, animated: true, completion: nil)
    }
   
}

extension ListeningViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

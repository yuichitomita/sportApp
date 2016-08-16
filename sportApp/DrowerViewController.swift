//
//  DrowerViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/08/11.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class DrowerViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    //Tableで使用する配列を設定する
    private let myItems: NSArray = ["TOP","新着","お気に入り"]
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Status Barの高さを取得する.
        let barHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        //Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView.frame = CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight)
        
        //DataSourceの設定する
        tableView.dataSource = self
        
        // Delegateを設定する
        tableView.delegate = self
        
        //Viewに追加する
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Cellが選択された際に呼び出されるデリゲートメソッド
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 遷移するViewを定義する
        switch indexPath.row {
        case 0:
            self.changeViewController("top")
        case 1:
            self.changeViewController("base")
        case 2:
            self.changeViewController("base")
        default:
            self.changeViewController("base")
        }
        
    }
    
    private func changeViewController(storyboardId: String) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let centerViewController: UIViewController! = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
        appDelegate.navigationController?.pushViewController(centerViewController, animated: false)
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    //Cellの総数を返すデータソースメソッド
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    //Cellに値を設定するデータソースメソッド
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        
        // Cellに値を設定する.
        cell.textLabel!.text = "\(myItems[indexPath.row])"
        
        return cell
    }

}

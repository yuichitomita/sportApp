//
//  MenuViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/11/04.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

protocol SlideMenuDeligate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tblMenuOptions: UITableView!
    @IBOutlet var btnCloseMenuOverlay: UIButton!
    
    var arrayMenuOptions = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    var delegate : SlideMenuDeligate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.delegate = self
        tblMenuOptions.dataSource = self
        
        tblMenuOptions.tableFooterView = UIView()
        
        updateArrayMenuOptions()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AccessToken.current != nil {
            //login済み
            self.userDefaults.synchronize()
            
            let url = URL(string: self.userDefaults.string(forKey: "picture")!)
            let imgData = NSData(contentsOf: url!)
            profileImgView.image = UIImage(data: imgData as! Data)
            
            let name = self.userDefaults.string(forKey: "name")
            nameLabel.text = name
            
            print(self.userDefaults.string(forKey: "picture")!)
            
        }else{
            profileImgView.image = UIImage(named: "guest")
            nameLabel.text = "Guest"
            
        }
    }
    
    func updateArrayMenuOptions() {
        arrayMenuOptions.append(["title":"新着", "icon":"NewIcon"])
        arrayMenuOptions.append(["title":"ランキング", "icon":"RankingIcon"])
        arrayMenuOptions.append(["title":"検索", "icon":"SerchIcon"])
        arrayMenuOptions.append(["title":"フォロー/視聴履歴", "icon":"FollowIcon"])
        arrayMenuOptions.append(["title":"マイページ", "icon":"MypageIcon"])
        arrayMenuOptions.append(["title":"運営からのお知らせ", "icon":"InfoIcon"])
        arrayMenuOptions.append(["title":"設定規約", "icon":"ConfigIcon"])
        
        tblMenuOptions.reloadData()
        
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton) {
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            let index = Int32(button.tag)
            if (button == self.btnCloseMenuOverlay){
                index == 1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}

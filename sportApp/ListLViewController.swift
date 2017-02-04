//
//  ListLViewController.swift
//  
//
//  Created by Tomi on 2016/08/11.
//
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire
import SwiftyJSON

class ListLViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var refreshControl = UIRefreshControl()
    @IBOutlet var tableView: UITableView!
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        // set up the refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBcastInfo()
        self.tableView.reloadData()
        super.viewWillAppear(animated)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! CustomTableViewCell
        
        cell.title.text = items[indexPath.row]["program_name"].string
        cell.accountName.text = items[indexPath.row]["user_name"].string
        let url = NSURL(string: items[indexPath.row]["program_img_path"].string!);
        let data = NSData(contentsOf: url as! URL)
        cell.accountImageView.image = UIImage(data: data as! Data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        let next = ListeningViewController()
        next.title = items[indexPath.row]["program_name"].string
        next.streamName = items[indexPath.row]["broadcast_id"].string!
        //next.streamName = "test"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func getBcastInfo(){
        
        let listUrl = "http://153.126.157.154:83/api/bcastInfo.php";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? 0)
            json.forEach{(_, data) in
                self.items.append(data)
                print(data)
                
            }
            self.tableView.reloadData()
        }
    }
    
    func refresh(sender:AnyObject) {
        self.items.removeAll()
        self.getBcastInfo()
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()

        
    }
}

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
    
 
    @IBOutlet var tableView: UITableView!
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    let accountImages = ["account1","account2","account3","account4","account5"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        getBcastInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
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
        //cell.accountImageView.image = UIImage(named: accountImages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルがタップされた時の処理
        let next = self.storyboard!.instantiateViewController(withIdentifier: "bcast")
        next.title = items[indexPath.row]["program_name"].string
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func getBcastInfo(){
  
        let listUrl = "http://153.126.157.154:83/api/bcastInfo.php";
        Alamofire.request(listUrl).responseJSON{ response in
            let json = JSON(response.result.value ?? 0)
            json.forEach{(_, data) in
                self.items.append(data)
                
            }
            self.tableView.reloadData()
        }
    }
}

//
//  ListLViewController.swift
//  
//
//  Created by Tomi on 2016/08/11.
//
//

import UIKit

class ListLViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
 
    @IBOutlet var tableView: UITableView!
    
    let titles = ["放送Title","のんびりタイムハート","寂しがり屋のラジオ","若林がお届けします","アゴトーク"]
    let accountNames = ["アカウント名","みさきち","寂しがり屋","若林","あごだし"]
    let accountImages = ["account1","account2","account3","account4","account5"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! CustomTableViewCell
        
        cell.title.text = titles[indexPath.row]
        cell.accountName.text = accountNames[indexPath.row]
        cell.accountImageView.image = UIImage(named: accountImages[indexPath.row])
        
        return cell
    }

}

//
//  ListLViewController.swift
//  
//
//  Created by Tomi on 2016/08/11.
//
//

import UIKit
import DrawerController

class ListLViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var drawerController: DrawerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TableViewのセクション数を返すメソッド
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     セクション毎のセル数を指定するメソッド
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Storyboardで設定したIdentifierでUITableViewCellのインスタンスを生成
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        return cell
    }


}

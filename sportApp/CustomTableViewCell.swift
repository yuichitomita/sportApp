//
//  CustomTableViewCell.swift
//  sportApp
//
//  Created by Tomi on 2016/11/23.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var accountImageView: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var accountName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

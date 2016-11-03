//
//  BaseTableViewCell.swift
//  sportApp
//
//  Created by Tomi on 2016/07/18.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

public class BaseTableViewCell :UITableViewCell {
    
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public override func awakeFromNib() {
    }
    
    public func setup() {
    }
    
    public class func height() -> CGFloat {
        return 48
    }
    
    public func setData(data: Any?) {
        self.backgroundColor = UIColor(hex: "F1F8E9")
        self.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        self.textLabel?.textColor = UIColor(hex: "9E9E9E")
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    override public func setHighlighted(highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override public func setSelected(selected: Bool, animated: Bool) {
    }
    
}
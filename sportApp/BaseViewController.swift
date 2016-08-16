//
//  BaseViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/08/11.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit
import PagingMenuController

class BaseViewController: UIViewController {
    private struct PagingMenuOptions: PagingMenuControllerCustomizable {
        private var componentType: ComponentType {
            return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
        }
        
        private var pagingControllers: [UIViewController] {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainNavVC = mainStoryboard.instantiateViewControllerWithIdentifier("list") as! ListLViewController
            let viewController1 = mainNavVC
            let viewController2 = UIViewController()
            let viewController3 = UIViewController()
            return [viewController1, viewController2, viewController3]
        }
        
        private struct MenuOptions: MenuViewCustomizable {
            var displayMode: MenuDisplayMode {
                return .SegmentedControl
            }
            var itemsOptions: [MenuItemViewCustomizable] {
                return [MenuItem1(), MenuItem2(),MenuItem3()]
            }
        }
        
        private struct MenuItem1: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "全て"))
            }
        }
        private struct MenuItem2: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "野球"))
            }
        }
        private struct MenuItem3: MenuItemViewCustomizable {
            var displayMode: MenuItemDisplayMode {
                return .Text(title: MenuItemText(text: "サッカー"))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the.
        
        view.backgroundColor = UIColor.blackColor()
        self.title = "新着"
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
        let menuButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.tapBarButtonItem(_:)))
        
        
        self.navigationItem.setLeftBarButtonItems([menuButton], animated: true)
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame.origin.y += 64
        pagingMenuController.view.frame.size.height -= 64
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        //pagingMenuController.didMoveToParentViewController(self)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ボタンが押されると呼ばれる処理
    func tapBarButtonItem(sender: AnyObject?) {
        //メニュー画面があいたり、ひらいたいり
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  BcastConfigViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/11/27.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class BcastConfigViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var programNameTxtField: UITextField!
    @IBOutlet var programDetailTxtField: UITextField!
    @IBOutlet var tagTxtField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tagView: UIView!
   
    var txtActiveField = UITextField()
    var programName = ""
    var programDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programNameTxtField.delegate = self
        programDetailTxtField.delegate = self
        tagTxtField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.handleKeyboardWillShowNotification(notification:)),
                                       name: NSNotification.Name.UIKeyboardDidShow,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.handleKeyboardWillHideNotification(notification:)),
                                       name: NSNotification.Name.UIKeyboardWillHide,
                                       object: nil)
    }
    
    // Viewが非表示になるたびに呼び出されるメソッド
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == programNameTxtField {
            programName = programNameTxtField.text!
        }
        if textField == programDetailTxtField {
            programDetail = programDetailTxtField.text!
        }
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(programName, forKey: "programName")
        userDefaults.set(programDetail, forKey: "programDtail")
        userDefaults.synchronize()
        
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtActiveField = textField
        return true
    }
    
    @objc func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = txtActiveField.frame.origin.y + txtActiveField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }else {
            scrollView.contentOffset.y = (txtLimit + self.tagView.frame.origin.y) - kbdLimit
        }
    }
    
    @objc func handleKeyboardWillHideNotification(notification: NSNotification) {
        self.scrollView.contentOffset.y = 0
    }

}

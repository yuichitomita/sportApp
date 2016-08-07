//
//  ViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/04/09.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var height:CGFloat!
    var width:CGFloat!
    //Totalのページ数
    let pNum: Int = 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        
        width = screenSize.width
        let img1 = UIImage(named: "1.jpg")
        let imgWidth = img1?.size.width
        let imgHeight = img1?.size.height
        
        height = width * imgHeight!/imgWidth!
        
        for i in 0 ..< pNum {
            let n = i+1
            
            //UIImageViewのインスタンス
            let image = UIImage(named: "\(n).jpg")!
            let imageView = UIImageView(image: image)
            var rect = imageView.frame
            rect.size.height = height
            rect.size.width = width
            imageView.frame = rect
            imageView.tag = n
            
            //UIScrollViewのインスタンスに画像を貼り付ける
            self.scrollView.addSubview(imageView)
            
        }
        
        setupScrollImages()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScrollImages() {
        
        //ダミー画像
        let imageDummy = UIImage(named: "1.jpg")!
        var imgView = UIImageView(image: imageDummy)
        var subviews = scrollView.subviews
        
        //描画開始のx,y 位置
        var px:CGFloat = 0.0
        let py:CGFloat = 100.0
        
        for i in 0 ..< subviews.count {
            imgView = subviews[i] as! UIImageView
            if (imgView.isKindOfClass(UIImageView) && imgView.tag > 0) {
                var viewFrame = imgView.frame
                viewFrame.origin = CGPointMake(px, py)
                imgView.frame = viewFrame
                
                px += (width)
            }
        }
        
        //UIScrollViewのコンテンツサイズを画像のtotalサイズに合わせる
        let nWidth:CGFloat = width * CGFloat(pNum)
        scrollView.contentSize = CGSizeMake(nWidth, height)
        
    }
    
    
    
    
}


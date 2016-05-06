//
//  ListeningViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/04/09.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit
import lf

class ListeningViewController: UIViewController {

    var streamName:String? = "live"
    var rtmpConnection:RTMPConnection = RTMPConnection()
    var rtmpStream:RTMPStream!
    
    var playButton:UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("▶︎", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(30)
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.addTarget(self, action: #selector(ListeningViewController.onClickPlay(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(playButton)

        rtmpStream = RTMPStream(rtmpConnection: rtmpConnection)
        rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(ListeningViewController.rtmpStatusHandler(_:)), observer: self)
        rtmpConnection.connect("rtmp://153.126.157.154/live")
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        playButton.frame = CGRect(x: view.bounds.width / 2 - 30 , y: view.bounds.height / 2 - 30 , width: 60, height: 60)
        rtmpStream.view.frame = view.frame
    }
    
    func rtmpStatusHandler(notification:NSNotification) {
        let e:Event = Event.from(notification)
        if let data:ASObject = e.data as? ASObject , code:String = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.ConnectSuccess.rawValue:
                rtmpStream.play(streamName)
            default:
                break
            }
        }
    }
    
    func onClickPlay(sender:UIButton) {
        if (sender.selected) {
            UIApplication.sharedApplication().idleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector:#selector(ListeningViewController.rtmpStatusHandler(_:)), observer: self)
            sender.setTitle("▶︎", forState: .Normal)
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = true
            rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(ListeningViewController.rtmpStatusHandler(_:)), observer: self)
            rtmpConnection.connect(Preference.defaultInstance.uri!)
            //sharedObject!.connect(rtmpConnection)
            sender.setTitle("■", forState: .Normal)
        }
        sender.selected = !sender.selected
    }


}
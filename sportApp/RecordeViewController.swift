//
//  RecordeViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/04/09.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit
import AVFoundation
import lf

struct Preference {
    static let defaultInstance:Preference = Preference()
    var uri:String? = "rtmp://153.126.157.154/live/"
    var streamName:String? = "live"
}


class RecordeViewController: UIViewController {
    var rtmpConnection:RTMPConnection = RTMPConnection()
    var rtmpStream:RTMPStream!
    var sharedObject:RTMPSharedObject!
    
    var publishButton:UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("●", forState: .Normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    
    var currentPosition:AVCaptureDevicePosition = AVCaptureDevicePosition.Back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        navigationItem.leftBarButtonItem =
        UIBarButtonItem(title: "Preference", style: .Plain, target: self, action: "showPreference:")
        sharedObject = RTMPSharedObject.getRemote("test", remotePath: Preference.defaultInstance.uri!, persistence: false)
        */
        
        /*
        httpStream = HTTPStream()
        httpStream.attachScreen(ScreenCaptureSession())
        httpStream.publish("hello")
        httpService = HTTPService(domain: "", type: "_http._tcp", name: "lf", port: 8080)
        httpService.startRunning()
        httpService.addHTTPStream(httpStream)
        */
        
        rtmpStream = RTMPStream(rtmpConnection: rtmpConnection)
        rtmpStream.syncOrientation = true
        rtmpStream.attachAudio(AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
        // rtmpStream.attachCamera(AVMixer.deviceWithPosition(.Back))
        // rtmpStream.attachScreen(ScreenCaptureSession())
        
        //rtmpStream.captureSettings = [
        //    "continuousAutofocus": true,
        //    "continuousExposure": true,
        //]
        
        publishButton.addTarget(self, action: Selector("onClickPublish:"), forControlEvents: .TouchUpInside)
        
        //view.addSubview(rtmpStream.view)
        
        
        
        // videoBitrateSlider.value = Float(RTMPStream.defaultVideoBitrate) / 1024
        // audioBitrateSlider.value = Float(RTMPStream.defaultAudioBitrate) / 1024
        
        view.addSubview(publishButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        publishButton.frame = CGRect(x: view.bounds.width - 44 - 20, y: view.bounds.height - 44 - 20, width: 44, height: 44)
        rtmpStream.view.frame = view.frame
    }
    
    func onClickPublish(sender:UIButton) {
        if (sender.selected) {
            UIApplication.sharedApplication().idleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector: Selector("rtmpStatusHandler:"), observer: self)
            sender.setTitle("●", forState: .Normal)
        } else {
            UIApplication.sharedApplication().idleTimerDisabled = true
            //rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:Selector("rtmpStatusHandler:"), observer: self)
            rtmpConnection.connect(Preference.defaultInstance.uri!)
            
            rtmpStream!.publish(Preference.defaultInstance.streamName!)
            //sharedObject!.connect(rtmpConnection)
            
            sender.setTitle("■", forState: .Normal)
        }
        sender.selected = !sender.selected
    }
    
    func rtmpStatusHandler(notification:NSNotification) {
        rtmpStream!.publish(Preference.defaultInstance.streamName!)
        sharedObject!.connect(rtmpConnection)
        
        /*
        let e:Event = Event.from(notification)
        if let data:ASObject = e.data as? ASObject , code:String = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.ConnectSuccess.rawValue:
                rtmpStream!.publish(Preference.defaultInstance.streamName!)
                sharedObject!.connect(rtmpConnection)
            default:
                break
            }
        }
        */
    }
}


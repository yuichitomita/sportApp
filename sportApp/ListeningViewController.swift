//
//  ListeningViewController.swift
//  sportApp
//
//  Created by Tomi on 2017/02/04.
//  Copyright © 2017年 slj. All rights reserved.
//

import UIKit
import lf
import AVFoundation

class ListeningViewController: UIViewController {

    var rtmpConnection:RTMPConnection = RTMPConnection()
    var rtmpStream:RTMPStream!
    var sharedObject:RTMPSharedObject!
    let uri:String? = "rtmp://153.126.157.154/live/"
    var streamName = "test"
    var items: [[String: String?]] = []
    let lfView:GLLFView = GLLFView(frame: CGRect.zero)
    
    var publishButton:UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = UIColor.blue
        button.setTitle("●", for: UIControlState())
        button.layer.masksToBounds = true
        return button
    }()
    
    var pauseButton:UIButton = {
        let button:UIButton = UIButton()
        button.backgroundColor = UIColor.blue
        button.setTitle("P", for: UIControlState())
        button.layer.masksToBounds = true
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleRate:Double = 44_100
        
        do {
            try AVAudioSession.sharedInstance().setPreferredSampleRate(sampleRate)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeVideoChat)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
        

        rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.syncOrientation = true
        rtmpStream.attachAudio(AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio), automaticallyConfiguresApplicationAudioSession: false)
        
        //rtmpStream.addObserver(self, forKeyPath: "currentFPS", options: NSKeyValueObservingOptions.new, context: nil)
        
        rtmpStream.captureSettings = [
            "fps": 30, // FPS
            "sessionPreset": AVCaptureSessionPreset1280x720, // input video width/height
            "continuousAutofocus": false, // use camera autofocus mode
            "continuousExposure": false, //  use camera exposure mode
        ]

        rtmpStream.audioSettings = [
            "muted": false, // mute audio
            "bitrate": 32 * 1024,
            "sampleRate": sampleRate,
        ]
        
        
        rtmpStream.videoSettings = [
            "width": 1280,
            "height": 720,
        ]
        
        publishButton.addTarget(self, action: #selector(LiveViewController.on(publish:)), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(LiveViewController.on(pause:)), for: .touchUpInside)
        
        
        lfView.attachStream(rtmpStream)
        
        view.addSubview(lfView)
        view.addSubview(pauseButton)
        view.addSubview(publishButton)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lfView.frame = view.bounds
    
        pauseButton.frame = CGRect(x: view.bounds.width - 44 - 20, y: view.bounds.height - 44 * 2 - 20 * 2, width: 44, height: 44)
        publishButton.frame = CGRect(x: view.bounds.width - 44 - 20, y: view.bounds.height - 44 - 20, width: 44, height: 44)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func on(pause:UIButton) {
        print("pause")
        rtmpStream.togglePause()
    }
    
    func on(publish:UIButton) {
        if (publish.isSelected) {
            UIApplication.shared.isIdleTimerDisabled = false
            rtmpConnection.close()
            rtmpConnection.removeEventListener(Event.RTMP_STATUS, selector:#selector(LiveViewController.rtmpStatusHandler(_:)), observer: self)
            publish.setTitle("●", for: UIControlState())
        } else {
            UIApplication.shared.isIdleTimerDisabled = true
            rtmpConnection.addEventListener(Event.RTMP_STATUS, selector:#selector(LiveViewController.rtmpStatusHandler(_:)), observer: self)
            rtmpConnection.connect(self.uri!)
            
            publish.setTitle("■", for: UIControlState())
        }
        publish.isSelected = !publish.isSelected
    }
    
    func rtmpStatusHandler(_ notification:Notification) {
        let e:Event = Event.from(notification)
        if let data:ASObject = e.data as? ASObject , let code:String = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                rtmpStream.play(self.streamName)
            default:
                break
            }
        }
    }
    
}

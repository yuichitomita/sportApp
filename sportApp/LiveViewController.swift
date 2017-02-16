//
//  LiveViewController.swift
//  sportApp
//
//  Created by Tomi on 2017/01/28.
//  Copyright © 2017年 slj. All rights reserved.
//

import lf
import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON
import JSQMessagesViewController
import SnapKit

final class LiveViewController: JSQMessagesViewController {
    var rtmpConnection:RTMPConnection = RTMPConnection()
    var rtmpStream:RTMPStream!
    var sharedObject:RTMPSharedObject!
    let uri:String? = "rtmp://153.126.157.154/live/"
    var streamName = "30"
    var items: [[String: String?]] = []
    let lfView:GLLFView = GLLFView(frame: CGRect.zero)
    
    // message
    var messages:[JSQMessage] = []
    private var incomingBuddle: JSQMessagesBubbleImage!
    private var outgoingBuddle: JSQMessagesBubbleImage!
    private var incomingAvatar: JSQMessagesAvatarImage!
    
    
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
        
        //rtmp接続準備
        rtmpInitialSettings()
        
        //チャット機能準備
        chatInitialSettings()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
     
        lfView.snp.makeConstraints{ (make) -> Void in
            make.height.equalTo(self.view.bounds.height / 3)
            make.width.equalTo(self.view.bounds.width)
        }
        
        pauseButton.snp.makeConstraints{ (make) -> Void in
            make.height.width.equalTo(44)
            make.centerX.equalTo(lfView).offset(-30)
            make.centerY.equalTo(lfView).offset(20)
        }
        
        publishButton.snp.makeConstraints{ (make) -> Void in
            make.height.width.equalTo(44)
            make.centerX.equalTo(lfView).offset(30)
            make.centerY.equalTo(lfView).offset(20)
        }
        
        
        self.collectionView?.collectionViewLayout.sectionInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        
        
    }
    
    
    private func rtmpInitialSettings() {
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
    
    
        rtmpStream.captureSettings = [
            "fps": 30, // FPS
            "sessionPreset": AVCaptureSessionPreset1280x720, // input video width/height
            "continuousAutofocus": false, // use camera autofocus mode
            "continuousExposure": false, //  use camera exposure mode
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
    
        setStreamName()
        print(self.streamName)

    }
    
    
    private func chatInitialSettings(){
        
        // キーボードのジェスチャー登録.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        //Room参加
        SocketIOManager.sharedInstance.joinRoom("room-1")
        
        
        // Node.jsからのメッセージをブロードキャストし、画面にそれを表示。
        SocketIOManager.sharedInstance.getChatMessage {
            (messageInfo)-> Void in
            self.messages.append(messageInfo)
            self.finishReceivingMessage(animated: true)
        }

        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBuddle = bubbleFactory.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBuddle = bubbleFactory.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = .zero
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        // 新しいメッセージデータを追加する.
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.messages.append(message)
        self.finishReceivingMessage(animated: true)
        
        // サーバーへメッセージ送信.
        SocketIOManager.sharedInstance.sendMessage("room-1", userId: "2", userName: senderDisplayName, msg: text)
        
        // TextFieldのテキストをクリア.
        self.inputToolbar.contentView?.textView?.text = ""
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        if messages[indexPath.item].senderId == self.senderId() {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(
                with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(
                with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func senderId() -> String {
        return self.streamName
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        
        if messages[indexPath.item].senderId != self.senderId() {
            incomingAvatar = JSQMessagesAvatarImageFactory().avatarImage(withUserInitials: messages[indexPath.row].senderDisplayName, backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12))
            
            return incomingAvatar
        }
        
        return nil
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId() {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func senderDisplayName() -> String {
        return "test"
    }
    
    
    func on(pause:UIButton) {
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
                rtmpStream.publish(self.streamName)
            default:
                break
            }
        }
    }
    
    //streamNameを取得
    func setStreamName() {
        
        let listUrl = "http://153.126.157.154:83/api/registerBcastInfo.php";
            Alamofire.request(listUrl).responseJSON{ response in
                guard let object = response.result.value else {
                    return
                }
                let json = JSON(object)
                self.streamName =  json["stream_name"].stringValue
            }
    }
}


//
//  ChatViewController.swift
//  sportApp
//
//  Created by Tomi on 2016/11/27.
//  Copyright © 2016年 slj. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftyJSON

class ChatViewController: JSQMessagesViewController {
    
    var messages:[JSQMessage] = []
    private var incomingBuddle: JSQMessagesBubbleImage!
    private var outgoingBuddle: JSQMessagesBubbleImage!
    private var incomingAvatar: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        initialSettings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    private func initialSettings(){
        
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
        return "targetUser"
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
        return "passion"
    }
}


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
import SnapKit
import SocketIO

class ChatViewController: JSQMessagesViewController {
    private let socketURL = URL(string: "http://153.126.157.154:1337/chat")
    var socket: SocketIOClient!
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var bcastInfoButton: UIButton!
    private var messages:[JSQMessage] = []
    private var incomingBuddle: JSQMessagesBubbleImage!
    private var outgoingBuddle: JSQMessagesBubbleImage!
    private var incomingAvatar: JSQMessagesAvatarImage!
    
    //test
    private let targetUser: JSON = ["senderId": "targetUser","displayName": "passion"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView?.backgroundColor  = UIColor.lightGray
        
        initialSettings()
        bcastInfoButton.addTarget(self, action: #selector(self.openButtonTouchUpInside(_:)), for: .touchUpInside)
        
        self.view.addSubview(bcastInfoButton)
        self.view.addSubview(self.imgView)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        addMessage(withId: "test", name: "aaa", text: "test")
        
        finishReceivingMessage()
    
    }
    
    override func updateViewConstraints() {
        self.imgView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.navigationController!.navigationBar.snp.bottom).inset(0)
            make.width.equalTo(self.view).inset(0)
            make.bottom.equalTo(self.collectionView!.snp.top)
        }
        
        self.bcastInfoButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.imgView).inset(4)
            make.trailing.equalTo(self.imgView).inset(4)
            make.size.equalTo(44)
        }
        
        super.updateViewConstraints()
    }
    
    private func initialSettings(){
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBuddle = bubbleFactory.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBuddle = bubbleFactory.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        self.incomingAvatar = JSQMessagesAvatarImageFactory().avatarImage(withUserInitials: "tomi", backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor: UIColor.white, font: UIFont.systemFont(ofSize: 12))
        
        self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = .zero
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
    
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(message)
        self.finishSendingMessage(animated: true)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    func openButtonTouchUpInside(_ sender: AnyObject) {
        //let contentVC = ModalViewController()
        let storyboard: UIStoryboard = self.storyboard!
        let contentVC = storyboard.instantiateViewController(withIdentifier: "modal")
        
        //define use of popover
        contentVC.modalPresentationStyle = .popover
        //set size
        contentVC.preferredContentSize = CGSize(width: 350, height: 350)
        //set origin
        contentVC.popoverPresentationController?.sourceView = view

        let point = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        contentVC.popoverPresentationController?.sourceRect.contains(point)
        
        //set arrow direction
        contentVC.popoverPresentationController?.permittedArrowDirections = .unknown
        //set delegate
        contentVC.popoverPresentationController?.delegate = self
        //present
        present(contentVC, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        return messages[indexPath.item].senderId == self.senderId() ? outgoingBuddle : incomingBuddle
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func senderId() -> String {
        return "targetUser"
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: name, text: text)
        messages.append(message)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        
        if messages[indexPath.item].senderId != self.senderId() {
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

// MARK : UIPopoverPresentationControllerDelegate
extension ChatViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

//
//  SocketIOManager.swift
//  sportApp
//
//  Created by Tomi on 2017/02/11.
//  Copyright © 2017年 slj. All rights reserved.
//

import Foundation
import SocketIO
import JSQMessagesViewController
import SwiftyJSON

class SocketIOManager: NSObject {
    
    // Singleton.
    class var sharedInstance: SocketIOManager {
        struct Static {
            static let instance: SocketIOManager = SocketIOManager()
        }
        return Static.instance
    }
    
    private override init() {super.init()}
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://153.126.157.154:1337")! as URL)
    
    // 接続.
    func establishConnection() {
        socket.joinNamespace("/chat")
        socket.on("connect"){ data,ack in
            print("iOS側からサーバーへsocket接続.")
        }
        socket.connect()
    }
    
    // 切断.
    func closeConnection() {
        socket.on("disconnect"){ data,ack  in
            print("socketが切断されました")
        }
        socket.disconnect()
    }
    
    // メッセージ送信.
    func sendMessage(_ room: String, userId: String, userName: String, msg: String) {
        let data = ["room":room,"userId":userId,"userName":userName,"msg":msg]
        socket.emit("emit_from_client", data)
    }
    
    
    // メッセージ受信.
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: JSQMessage) -> Void) {
        socket.on("emit_from_server") { (dataArray, socketAck) -> Void in
            print(dataArray[0])
            let json = JSON(dataArray[0])
            let message = json["msg"].stringValue
            let userId = json["userId"].stringValue
            let userName = json["userName"].stringValue
            
            let jsqMessage = JSQMessage(senderId: userId , displayName: userName , text: message)
            completionHandler(jsqMessage)
        }
    }
    
    //room参加
    func joinRoom(_ room: String) {
        let data = ["room": room]
        socket.emit("join_room", data)
    }
}

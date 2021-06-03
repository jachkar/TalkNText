//
//  ChatViewController.swift
//  TalkNText
//
//  Created by Julien Achkar on 20/04/2021.
//

import UIKit
import FirebaseDatabase
import GoogleSignIn
import IQKeyboardManagerSwift
import FirebaseMessaging
import FirebaseAuth

class ChatViewController: FTChatMessageTableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = Constants.Colors.BackgroundColor

        setupNavigation()
        fetchMessages()
    }
    
    func setupNavigation() {
        self.title = roomID
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(didPressClose))
    }
    
    fileprivate func getMessageModel(messageSnapshot: DataSnapshot) -> FTChatMessageModel? {
        let messageDict = messageSnapshot.value as! Dictionary<String, Any>
        let userModel = messageDict["userModel"] as! Dictionary<String, String>
        guard let userName = userModel["name"],
            let userID = userModel["id"],
            let text = messageDict["message"] else {
                return nil
        }
        let messageTime = messageDict["timeStamp"]! as? String
        let messageType = FTChatMessageType.text //FTChatMessageType.getMessageTypeFromString(messageType: messageDict[Constants.MessageFields.messageType]!)
        let userIconURL = userModel["photo_profile"]
        let imageURL = userModel["photo_profile"]
        let senderModel = FTChatMessageUserModel(id: userID, name: userName, icon_url: userIconURL, extra_data: nil, isSelf: Auth.auth().currentUser?.uid == userID)
        if messageType == .image {
            let imageChatModel = FTChatMessageImageModel(data: text as? String, time: Utilities.dateFromSeconds(dateInMillis: messageTime!), extraDic: nil, from: senderModel, type: messageType,snapshot: messageSnapshot)
            imageChatModel.imageUrl = imageURL
            return imageChatModel
        }
        return FTChatMessageModel(data: text as? String, time: Utilities.dateFromSeconds(dateInMillis: messageTime!), extraDic: nil, from: senderModel, type: messageType,snapshot : messageSnapshot)
    }
    
    func fetchMessages() {
        var messagesDBName = "chatmodel"
        
        if roomID != nil {
            messagesDBName = "chatmodel-\(roomID!)"
        }
        
        let messageDB = Database.database().reference().child(messagesDBName)
        messageDB.keepSynced(true)
        
        let strongSelf = self
        messageDB.observe(.childAdded) { (snapshot) in
              if let messageModel = strongSelf.getMessageModel(messageSnapshot: snapshot) {
                strongSelf.chatMessageDataArray.append(messageModel)
                strongSelf.origanizeAndReload()
                
                let section = strongSelf.numberOfSections(in: strongSelf.tableView) - 1
                let item = strongSelf.tableView.numberOfRows(inSection: section) - 1
                let indexPath = IndexPath.init(item: item, section: section)
                let visibleIndexes = strongSelf.tableView.indexPathsForVisibleRows
                
                if ((visibleIndexes?.contains(indexPath))! || (visibleIndexes?.contains(IndexPath.init(row: 0, section: 0)))!) {
                    strongSelf.scrollToBottom(true)
                }
            }
        }
        
        messageDB.observe(.childRemoved) { (snapshot) in
            let index = self.indexOfMessage(snapshot)
            if index > 0 {
                strongSelf.chatMessageDataArray.remove(at: index)
                strongSelf.origanizeAndReload()
            }
        }
    }
    
    func indexOfMessage(_ snapshot: DataSnapshot) -> Int {
        var index = 0
        let messagesArray = self.chatMessageDataArray as NSArray
        let array = messagesArray.map {($0 as! FTChatMessageModel).dataSnapshot}
        
        for message in array {
            if snapshot.key == message!.key {
                return index
          }
          index += 1
        }
        return -1
    }
}

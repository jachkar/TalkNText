//
//  FTChatMessageTableViewController.swift
//  ChatMessageDemoProject
//
//  Created by liufengting on 16/2/28.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

import UIKit
import FirebaseDatabase
import RSKKeyboardAnimationObserver

class FTChatMessageTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, FTChatMessageHeaderDelegate, UITextViewDelegate {
    
    var roomID: String!
    
    var chatMessageDataArray : [FTChatMessageModel] = [] {
        didSet {
            self.origanizeAndReload()
        }
    }
    open var messageArray : [[FTChatMessageModel]] = []
    var delegete : FTChatMessageDelegate?
    var dataSource : FTChatMessageDataSource?
    var messageInputMode : FTChatMessageInputMode = FTChatMessageInputMode.none
    
    private var isVisibleKeyboard = true

    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLayoutGuideTopAndTableViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var growingTextView: RSKGrowingTextView!
    @IBOutlet weak var tableView: UITableView!
    

//    lazy var messageRecordView : FTChatMessageRecorderView! = {
//        let recordView : FTChatMessageRecorderView! = Bundle.main.loadNibNamed("FTChatMessageRecorderView", owner: nil, options: nil)?[0] as? FTChatMessageRecorderView
//        recordView.frame = CGRect(x: 0, y: FTScreenHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
//        return recordView
//    }()

//    lazy var messageAccessoryView : FTChatMessageAccessoryView! = {
//        let accessoryView = Bundle.main.loadNibNamed("FTChatMessageAccessoryView", owner: nil, options: nil)?[0] as! FTChatMessageAccessoryView
//        accessoryView.frame = CGRect(x: 0, y: FTScreenHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
//        return accessoryView
//    }()
    
     override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: FTDefaultInputViewHeight, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Constants.Colors.BackgroundColor
            
        let header = UIView(frame: CGRect( x: 0, y: 0, width: FTScreenWidth, height: FTDefaultMargin*2))
        header.backgroundColor = Constants.Colors.BackgroundColor
        tableView.tableHeaderView = header
            
        let footer = UIView(frame: CGRect( x: 0, y: 0, width: FTScreenWidth, height: FTDefaultInputViewHeight))
        footer.backgroundColor = Constants.Colors.BackgroundColor
        tableView.tableFooterView = footer
            
        self.view.addSubview(tableView)
            
        if UserDefaults.standard.object(forKey: "AppLanguage") as? String != nil {
            let language = UserDefaults.standard.object(forKey: "AppLanguage") as! String
            if language.hasPrefix("ar") {
                growingTextView.textAlignment = .right
            }
        }
        
        let textViewPlaceholder = "Write a message..."
        growingTextView.placeholder = textViewPlaceholder as NSString
        growingTextView.layer.cornerRadius = FTDefaultInputViewTextCornerRadius
        growingTextView.layer.borderColor = UIColor.lightGray.cgColor
        growingTextView.layer.borderWidth = 0.5
        growingTextView.textContainerInset = FTDefaultInputTextViewEdgeInset
        growingTextView.delegate = self
        growingTextView.textColor = UIColor.lightGray
        growingTextView.returnKeyType = .send
        self.view.bringSubviewToFront(growingTextView)

    //        self.view.addSubview(messageRecordView)
    //        self.view.addSubview(messageAccessoryView)
            
        DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.scrollToBottom(false)
        }
    }

       
    // MARK: - Object Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
           
        self.registerForKeyboardNotifications()
        
        //        messageAccessoryView.setupAccessoryView()
    }
       
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
           
        self.unregisterForKeyboardNotifications()
    }
       
       // MARK: - Helper Methods
    private func adjustContent(for keyboardRect: CGRect) {
        let keyboardHeight = keyboardRect.height
        self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length + 5 : 0.0
        
        DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + 1) {
//            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.isVisibleKeyboard ? keyboardRect.size.height : FTDefaultInputViewHeight, right: 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.isVisibleKeyboard ? keyboardRect.size.height : FTDefaultInputViewHeight, right: 0)
            self.scrollToBottom(true)
        }
        self.view.layoutIfNeeded()
    }
       
    private func registerForKeyboardNotifications() {
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
            willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                self.isVisibleKeyboard = isShowing
                self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
            }
        )
           
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
        }, onComplete: nil)
    }
       
    private func unregisterForKeyboardNotifications() {
        self.rsk_unsubscribeKeyboard()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if (text == "\n") {
                if (textView.text as NSString).length > 0 {
                    self.ft_chatMessageInputViewShouldDoneWithText(textView.text)
                    self.clearText()
                }
                return false
            }
            return true
        }
      
      //MARK: - clearText -
    func clearText() {
        growingTextView.text = ""
        self.ft_chatMessageInputViewShouldUpdateHeight(FTDefaultInputViewHeight)
    }
    
    internal func addNewMessage(_ message : FTChatMessageModel) {
        
        let text = message.messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isStringNull(string: text) {
            return
        }

        var messageDict: [String: Any] = [:]
        messageDict["message"] = text
        messageDict["timeStamp"] = message.messageTimeStamp
        
        var userModel: [String: String] = [:]
        userModel["id"] = message.messageSender.senderId
        userModel["name"] = message.messageSender.senderName
        userModel["photo_profile"] = message.messageSender.senderIconUrl
        messageDict["userModel"] = userModel

        print(messageDict)
        // Push data to Firebase Database
        
        var messagesDBName = "chatmodel"
        
        if roomID != nil {
            messagesDBName = "chatmodel-\(roomID!)"
        }
        
        let messagesDB = Database.database().reference().child(messagesDBName)
        
        messagesDB.childByAutoId().setValue(messageDict) {
            (error, reference) in

            if error != nil{
                print(error!)
            } else {

            }
        }
        
        //chatMessageDataArray.append(message);
        //self.origanizeAndReload()
        //self.scrollToBottom(true)
    }
    
    internal func addNewImageMessage(_ message : FTChatMessageImageModel) {
//        var messageDict: [String: String] = [:]
//        messageDict[Constants.MessageFields.text] = message.messageText
//        messageDict[Constants.MessageFields.name] = message.messageSender.senderName
//        messageDict[Constants.MessageFields.userID] = message.messageSender.senderId
//        messageDict[Constants.MessageFields.messageTime] = message.messageTimeStamp
//        messageDict[Constants.MessageFields.messageType] = FTChatMessageType.getMessageStringFromType(messageType: message.messageType)
//        messageDict[Constants.MessageFields.photoURL] = message.messageSender.senderIconUrl
//        messageDict[Constants.MessageFields.imageURL] = message.imageUrl
//
//        // Push data to Firebase Database
//        AppState.sharedInstance.firebaseRef.child(Constants.MessageFields.messages).childByAutoId().setValue(messageDict)
        
        //chatMessageDataArray.append(message);
        //self.origanizeAndReload()
        //self.scrollToBottom(true)
    }
    
    func origanizeAndReload() {
        var nastyArray : [[FTChatMessageModel]] = []
        var tempArray : [FTChatMessageModel] = []
        var tempId = ""
        
        if !chatMessageDataArray.isEmpty {
            for i in 0...chatMessageDataArray.count-1 {
                let message = chatMessageDataArray[i]
                if message.messageSender.senderId == tempId {
                    tempArray.append(message)
                } else {
                    tempId = message.messageSender.senderId;
                    if tempArray.count > 0 {
                        nastyArray.append(tempArray)
                    }
                    tempArray.removeAll()
                    tempArray.append(message)
                }
                
                if i == chatMessageDataArray.count - 1 {
                    if tempArray.count > 0 {
                        nastyArray.append(tempArray)
                    }
                }
            }
        }
        self.messageArray = nastyArray
        self.tableView.reloadData()
    }
}

//
//  FTChatMessageTableViewController+DataSource.swift
//  Demo
//
//  Created by liufengting on 16/9/27.
//  Copyright © 2016年 LiuFengting. All rights reserved.
//

import UIKit

extension FTChatMessageTableViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboradWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: - scrollToBottom -
    func scrollToBottom(_ animated: Bool) {
        if self.messageArray.count > 0 {
            let lastSection = self.messageArray.count - 1
            let lastSectionMessageCount = messageArray[lastSection].count - 1
            
            self.tableView.scrollToRow(at: IndexPath(row: lastSectionMessageCount, section: lastSection), at: UITableView.ScrollPosition.top, animated: animated)
        }
    }
    
    //MARK: - keyborad notification functions -
    @objc fileprivate func keyboradWillChangeFrame(_ notification : Notification) {
        
        if messageInputMode == FTChatMessageInputMode.keyboard {
            if let userInfo = (notification as NSNotification).userInfo {
                let duration = (userInfo["UIKeyboardAnimationDurationUserInfoKey"]! as AnyObject).doubleValue
                let keyFrame : CGRect = (userInfo["UIKeyboardFrameEndUserInfoKey"]! as AnyObject).cgRectValue
                let keyboradOriginY = min(keyFrame.origin.y, FTScreenHeight)
//                let inputBarHeight = growingTextView.frame.height
                
                UIView.animate(withDuration: duration!, animations: {
                    self.tableView.frame = CGRect(x: 0 , y: 0 , width: FTScreenWidth, height: keyboradOriginY)
                    self.scrollToBottom(true)
                    }, completion: { (finished) in
                        if finished {
                            if self.growingTextView.isFirstResponder {
                                self.dismissInputRecordView()
                                self.dismissInputAccessoryView()
                            }
                        }
                })
            }
        }
    }
    
    //MARK: - FTChatMessageInputViewDelegate -
    
    internal func ft_chatMessageInputViewShouldBeginEditing() {
        let originMode = messageInputMode
        messageInputMode = FTChatMessageInputMode.keyboard;
        switch originMode {
        case .keyboard: break
        case .accessory:
            self.dismissInputAccessoryView()
        case .record:
            self.dismissInputRecordView()
        case .none: break
        }
    }
    
    internal func ft_chatMessageInputViewShouldEndEditing() {
        messageInputMode = FTChatMessageInputMode.none;
    }
    
    internal func ft_chatMessageInputViewShouldUpdateHeight(_ desiredHeight: CGFloat) {
        var origin = growingTextView.frame;
        origin.origin.y = origin.origin.y + origin.size.height - desiredHeight;
        origin.size.height = desiredHeight;
        
        tableView.frame = CGRect(x: 0, y: 0, width: FTScreenWidth, height: origin.origin.y + FTDefaultInputViewHeight)
        self.scrollToBottom(true)
    }
    
    internal func ft_chatMessageInputViewShouldDoneWithText(_ textString: String) {
        if let mesageModel = FTChatMessageUserModel.getCurrentUserModel() {
            let message = FTChatMessageModel(data: textString, time: Utilities.getCurrentDateInString(), from: mesageModel, type: .text)
            
            self.addNewMessage(message)
        } else {
            print("App User not found")
        }
    }
    
    internal func ft_chatMessageInputViewShouldShowRecordView(){
        let originMode = messageInputMode
        let inputViewFrameHeight = self.growingTextView.frame.size.height
        if originMode == FTChatMessageInputMode.record {
            messageInputMode = FTChatMessageInputMode.none
            
            UIView.animate(withDuration: FTDefaultMessageDefaultAnimationDuration, animations: {
                
                self.tableView.frame = CGRect(x: 0, y: 0, width: FTScreenWidth, height: FTScreenHeight - inputViewFrameHeight + FTDefaultInputViewHeight )
//                self.messageRecordView.frame = CGRect(x: 0, y: FTScreenHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
                self.scrollToBottom(true)
                }, completion: { (finished) in
            })
        } else {
            switch originMode {
            case .keyboard:
                self.growingTextView.resignFirstResponder()
            case .accessory:
                self.dismissInputAccessoryView()
            case .none: break
            case .record: break
            }
            messageInputMode = FTChatMessageInputMode.record
            
            UIView.animate(withDuration: FTDefaultMessageDefaultAnimationDuration, animations: {
                self.tableView.frame = CGRect(x: 0, y: 0, width: FTScreenWidth, height: FTScreenHeight - inputViewFrameHeight - FTDefaultAccessoryViewHeight + FTDefaultInputViewHeight )
//                self.messageRecordView.frame = CGRect(x: 0, y: FTScreenHeight - FTDefaultAccessoryViewHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
                self.scrollToBottom(true)
                }, completion: { (finished) in
                    
            })
        }
    }
    
    internal func ft_chatMessageInputViewShouldShowAccessoryView(){
        let originMode = messageInputMode
        
        let inputViewFrameHeight = self.growingTextView.frame.size.height
        
        if originMode == FTChatMessageInputMode.accessory {
            messageInputMode = FTChatMessageInputMode.none
            UIView.animate(withDuration: FTDefaultMessageDefaultAnimationDuration, animations: {
                
                self.tableView.frame = CGRect(x: 0, y: 0, width: FTScreenWidth, height: FTScreenHeight - inputViewFrameHeight + FTDefaultInputViewHeight )
//                self.messageAccessoryView.frame = CGRect(x: 0, y: FTScreenHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
                self.scrollToBottom(true)
                }, completion: { (finished) in
                    
            })
        } else {
            switch originMode {
            case .keyboard:
                self.growingTextView.resignFirstResponder()
            case .record:
                self.dismissInputRecordView()
            case .none: break
            case .accessory: break
            }
            messageInputMode = FTChatMessageInputMode.accessory
            
            UIView.animate(withDuration: FTDefaultMessageDefaultAnimationDuration, animations: {
                
                self.tableView.frame = CGRect(x: 0, y: 0, width: FTScreenWidth, height: FTScreenHeight - inputViewFrameHeight - FTDefaultAccessoryViewHeight + FTDefaultInputViewHeight )
//                self.messageAccessoryView.frame = CGRect(x: 0, y: FTScreenHeight - FTDefaultAccessoryViewHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
                self.scrollToBottom(true)
                }, completion: { (finished) in
                    
            })
        }
    }
    
    //MARK: - dismissInputRecordView -
    fileprivate func dismissInputRecordView(){
        UIView.animate(withDuration: FTDefaultMessageDefaultAnimationDuration, animations: {
//            self.messageRecordView.frame = CGRect(x: 0, y: FTScreenHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
        })
    }
    
    //MARK: - dismissInputAccessoryView -
    fileprivate func dismissInputAccessoryView(){
        UIView.animate(withDuration: FTDefaultMessageDefaultAnimationDuration, animations: {
//            self.messageAccessoryView.frame = CGRect(x: 0, y: FTScreenHeight, width: FTScreenWidth, height: FTDefaultAccessoryViewHeight)
        })
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        switch self.messageInputMode {
        case .accessory:
            self.ft_chatMessageInputViewShouldShowAccessoryView()
        case .record:
            self.ft_chatMessageInputViewShouldShowRecordView()
        default:
            break;
        }
    }
    
    @objc(numberOfSectionsInTableView:)
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageArray.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messages : [FTChatMessageModel] = messageArray[section]
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let message = messageArray[section][0]
        let header = FTChatMessageHeader(frame: CGRect(x: 0,y: 0,width: tableView.frame.width,height: 40), senderModel: message.messageSender)
        header.headerViewDelegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @objc(tableView:heightForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageArray[indexPath.section][indexPath.row]
        return FTChatMessageCell.getCellHeightWithMessage(message, for: indexPath)
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messageArray[indexPath.section][indexPath.row]
        
        let cell = FTChatMessageCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: FTDefaultMessageCellReuseIndentifier, theMessage: message, for: indexPath)
        cell.backgroundColor = Constants.Colors.BackgroundColor
        
        return cell
    }
    
    @objc(tableView:didSelectRowAtIndexPath:)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - FTChatMessageHeaderDelegate -
    func ft_chatMessageHeaderDidTappedOnIcon(_ messageSenderModel: FTChatMessageUserModel) {
        print("tapped at user icon : \(messageSenderModel.senderName!)")
        
    }
    
    //MARK: - preferredInterfaceOrientationForPresentation -
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}

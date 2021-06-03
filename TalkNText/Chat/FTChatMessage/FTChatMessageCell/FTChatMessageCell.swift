//
//  FTChatMessageCell.swift
//  ChatMessageDemoProject
//
//  Created by liufengting on 16/2/28.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

import UIKit
import EasyTipView

//MARK: - FTChatMessageCell
class FTChatMessageCell: UITableViewCell, EasyTipViewDelegate {

    var message : FTChatMessageModel!
    var messageBubbleItem: FTChatMessageBubbleItem!
    var easyTipView: EasyTipView?
    var selectedBubbleItem: FTChatMessageBubbleItem?
    
    
    //MARK: - messageTimeLabel
    lazy var messageTimeLabel: UILabel! = {
        let label = UILabel(frame: CGRect.zero)
        label.font = FTDefaultTimeLabelFont
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    
    //MARK: - messageSenderNameLabel
    lazy var messageSenderNameLabel: UILabel! = {
        let label = UILabel(frame: CGRect.zero)
        label.font = FTDefaultTimeLabelFont
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    
    //MARK: - messageDeliverStatusView
    var messageDeliverStatusView : FTChatMessageDeliverStatusView? = {
        return FTChatMessageDeliverStatusView(frame: CGRect.zero)
    }()
    
    //MARK: - convenience init
    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, theMessage : FTChatMessageModel, for indexPath: IndexPath) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)

        message = theMessage

        let heightSoFar : CGFloat = 0
        var bubbleRect = CGRect.zero

        
        if indexPath.row == 0 {
            self.addTimeLabel()
//            heightSoFar += FTDefaultTimeLabelHeight

            self.addSenderLabel()
//            heightSoFar = (FTDefaultNameLabelHeight - FTDefaultSectionHeight)/2
        }
        
        let y : CGFloat = heightSoFar
        let bubbleWidth : CGFloat = FTChatMessageBubbleItem.getMessageBubbleWidthForMessage(theMessage)
        let bubbleHeight : CGFloat = FTChatMessageBubbleItem.getMessageBubbleHeightForMessage(theMessage)

        let x = theMessage.isUserSelf ? FTScreenWidth - (FTDefaultIconSize + FTDefaultMargin + FTDefaultMessageCellIconToMessageMargin) - bubbleWidth : FTDefaultIconSize + FTDefaultMargin + FTDefaultMessageCellIconToMessageMargin
        
        bubbleRect = CGRect(x: x, y: y, width: bubbleWidth, height: bubbleHeight)
        
        self.setupCellBubbleItem(bubbleRect, for: indexPath)
    }
    
    //MARK: - setupCellBubbleItem
    func setupCellBubbleItem(_ bubbleFrame: CGRect, for indexPath: IndexPath) {
        
        messageBubbleItem = FTChatMessageBubbleItem.getBubbleItemWithFrame(bubbleFrame, aMessage: message, for: indexPath)
        messageBubbleItem.addTarget(self, action: #selector(self.itemTapped(bubbleItem:)), for: UIControl.Event.touchUpInside)
        self.addSubview(messageBubbleItem)
        
        if message.isUserSelf  && message.messageDeliverStatus != FTChatMessageDeliverStatus.succeeded{
            self.addSendStatusView(bubbleFrame)
        }
    }

    //MARK: - addTimeLabel
    func addTimeLabel() {
        let timeLabelRect = CGRect(x: 0, y: -FTDefaultSectionHeight ,width: FTScreenWidth, height: FTDefaultSectionHeight/2);
        messageTimeLabel.frame = timeLabelRect
        messageTimeLabel.text = message.messageTimeStamp
        self.addSubview(messageTimeLabel)
    }
    
    //MARK: - addSenderLabel
    func addSenderLabel() {
        var nameLabelTextAlignment : NSTextAlignment = .right
        var nameLabelRect = CGRect( x: 0, y: -FTDefaultSectionHeight/2  , width: FTScreenWidth - (FTDefaultMargin + FTDefaultIconSize + FTDefaultMessageBubbleAngleWidth), height: FTDefaultSectionHeight/2)
 
        if message.isUserSelf == false {
            nameLabelRect.origin.x = FTDefaultMargin + FTDefaultIconSize + FTDefaultMessageBubbleAngleWidth
            nameLabelTextAlignment =  .left
        }
        
        messageSenderNameLabel.frame = nameLabelRect
        messageSenderNameLabel.text = ""//message.messageSender.senderName
        messageSenderNameLabel.textAlignment = nameLabelTextAlignment
        self.addSubview(messageSenderNameLabel)
    }
    
    //MARK: - addSendStatusView
    func addSendStatusView(_ bubbleFrame: CGRect) {
        let statusViewRect = CGRect(x: bubbleFrame.origin.x - FTDefaultMessageCellSendStatusViewSize - FTDefaultMargin, y: (bubbleFrame.origin.y + bubbleFrame.size.height - FTDefaultMessageCellSendStatusViewSize)/2, width: FTDefaultMessageCellSendStatusViewSize, height: FTDefaultMessageCellSendStatusViewSize)
        messageDeliverStatusView?.frame = statusViewRect
        messageDeliverStatusView?.setupWithDeliverStatus(message.messageDeliverStatus)
        self.addSubview(messageDeliverStatusView!)
    }
    
    // MARK: - Copy Actions
    @objc func itemTapped(bubbleItem: FTChatMessageBubbleItem) {
        print("message item tapped");
        //showMenu(bubbleItem: bubbleItem)
        if let parentView = bubbleItem.superview?.superview {
            var didFoundToolTip = false
            for subView in parentView.subviews {
                if subView.isKind(of: EasyTipView.classForCoder()) {
                    let tipView = subView as! EasyTipView
                    tipView.dismiss()
                    if !didFoundToolTip {
                        didFoundToolTip = true
                    }
                }
            }
            if didFoundToolTip {
                return
            }
        }
        print(bubbleItem.superview!.superview!.subviews)
        selectedBubbleItem = bubbleItem
        easyTipView = EasyTipView(text: "copy", preferences: EasyTipView.globalPreferences, delegate: self)
        easyTipView!.show(animated: true, forView: bubbleItem, withinSuperview: bubbleItem.superview?.superview)
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        let board = UIPasteboard.general
        board.string = selectedBubbleItem?.message.messageText
    }
}

// MARK: - FTChatMessageCell extension
extension FTChatMessageCell {

    internal class func getCellHeightWithMessage(_ theMessage : FTChatMessageModel, for indexPath: IndexPath) -> CGFloat{
        var cellDesiredHeight : CGFloat =  0;
//        cellDesiredHeight += FTDefaultMargin
        cellDesiredHeight += FTChatMessageBubbleItem.getMessageBubbleHeightForMessage(theMessage)
        cellDesiredHeight += FTDefaultMargin
        cellDesiredHeight = max(1, cellDesiredHeight)
        return cellDesiredHeight
    }
}







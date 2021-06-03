//
//  FTChatMessageHeader.swift
//  ChatMessageDemoProject
//
//  Created by liufengting on 16/2/28.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

import UIKit
import SDWebImage

protocol FTChatMessageHeaderDelegate {
    func ft_chatMessageHeaderDidTappedOnIcon(_ messageSenderModel : FTChatMessageUserModel)
}

class FTChatMessageHeader: UILabel {
    
    var iconButton : UIButton!
    var messageSenderModel : FTChatMessageUserModel!
    var headerViewDelegate : FTChatMessageHeaderDelegate?

    convenience init(frame: CGRect, senderModel: FTChatMessageUserModel ) {
        self.init(frame : frame)
        
//        self.isUserInteractionEnabled = false
        messageSenderModel = senderModel;
        self.setupHeader(URL(string: senderModel.senderIconUrl ?? ""), isSender: senderModel.isUserSelf)
    }
    
    fileprivate func setupHeader(_ imageUrl : URL?, isSender: Bool){
        self.backgroundColor = UIColor.clear
        
        let iconRect = isSender ? CGRect(x: self.frame.width-FTDefaultMargin-FTDefaultIconSize, y: FTDefaultMargin, width: FTDefaultIconSize, height: FTDefaultIconSize) : CGRect(x: FTDefaultMargin, y: FTDefaultMargin, width: FTDefaultIconSize, height: FTDefaultIconSize)
        iconButton = UIButton(frame: iconRect)
        iconButton.contentMode = .scaleAspectFill
        iconButton.backgroundColor = isSender ? FTDefaultOutgoingColor : FTDefaultIncomingColor
        iconButton.layer.cornerRadius = FTDefaultIconSize/2;
        iconButton.clipsToBounds = true
        iconButton.isUserInteractionEnabled = true
        iconButton.addTarget(self, action: #selector(self.iconTapped), for: UIControl.Event.touchUpInside)
        self.addSubview(iconButton)
        
        if (imageUrl != nil) {
            iconButton.sd_setImage(with: imageUrl, for: .normal, completed: nil)
        }
    }

    @objc func iconTapped() {
        if (headerViewDelegate != nil) {
            headerViewDelegate?.ft_chatMessageHeaderDidTappedOnIcon(messageSenderModel)
        }
    }
}

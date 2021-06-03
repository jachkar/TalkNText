//
//  PIPVideoVM.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import WebRTC

final class PIPVideoVM {
    var webRTCClient: WebRTCClient!
    var videoVM: VideoVM!
    
    init(webRTCClient: WebRTCClient, videoSource: VideoSource) {
        self.webRTCClient = webRTCClient
        videoVM = VideoVM(webRTCClient: webRTCClient, videoSource: videoSource)

    }

}

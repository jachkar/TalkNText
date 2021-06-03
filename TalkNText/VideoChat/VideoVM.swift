//
//  VideoVM.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import WebRTC

class VideoVM {
    var webRTCClient: WebRTCClient!
    var videoSource: VideoSource!
    
    init(webRTCClient: WebRTCClient, videoSource: VideoSource) {
        self.webRTCClient = webRTCClient
        self.videoSource = videoSource
    }
    
    func startRender(view: RTCVideoRenderer) {
        switch videoSource! {
        case .remote:
            webRTCClient.renderRemoteVideo(to: view)
        case .localCamera:
            webRTCClient.startCaptureLocalCameraVideo(renderer: view)
        case let .localFile(name):
            webRTCClient.startCaptureLocalVideoFile(name: name, renderer: view)
        }
    }

}

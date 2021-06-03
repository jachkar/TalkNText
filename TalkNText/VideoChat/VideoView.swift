//
//  VideoView.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import WebRTC

final class VideoView: RTCEAGLVideoView {
    var vm: VideoVM! {
        didSet {
            vm.startRender(view: self)
        }
    }
}


enum VideoSource {
    case remote
    case localCamera
    case localFile(name: String)
    
    init(localVideoSource: WebRTCClient.LocalVideoSource) {
        switch localVideoSource {
        case .camera:
            self = .localCamera
        case let .file(name):
            self = .localFile(name: name)
            
        default:
            self = .localCamera
        }
        
    }
}



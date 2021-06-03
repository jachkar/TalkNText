//
//  WebRTCView.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import UIKit
import WebRTC


final class WebRTCView: UIView, RTCVideoViewDelegate {
    let videoView = VideoView(frame: .zero)
    var videoSize = CGSize.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        videoView.delegate = self
        addSubview(videoView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        videoView.delegate = self
        addSubview(videoView)
    }

    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        self.videoSize = size
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard
            videoSize.width > 0 && videoSize.height > 0
            else {
                videoView.frame = bounds
                return
        }

        var videoFrame = AVMakeRect(aspectRatio: videoSize, insideRect: bounds)
        videoFrame.size.aspectFitSize(in: bounds.size)
        videoView.frame = videoFrame
        videoView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}


extension CGSize {

    mutating func aspectFitSize(in container: CGSize) {
        let scale = aspectFitScale(in: container)
        width = width * CGFloat(scale)
        height = height * CGFloat(scale)
    }

    func aspectFitScale(in container: CGSize) -> CGFloat {

        if height <= container.height && width > container.width {
            return container.width / width
        }
        if height > container.height && width <= container.width {
            return container.height / height
        }

        if height > container.height && width > container.width ||
            height <= container.height && width <= container.width {
            return min(container.width / width, container.height / height)
        }

        return 1.0
    }
}


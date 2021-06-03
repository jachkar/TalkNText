//
//  PIPVideoVC.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import UIKit
import PIPKit


final class PIPVideoVC: UIViewController, PIPUsable {

    var viewModel: PIPVideoVM!
    @IBOutlet var video: VideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        video.vm = viewModel.videoVM
    }
    
    var initialPosition: PIPPosition {
        return .topRight
    }
    
    var pipSize: CGSize {
        return .init(width: 100, height: 100)
    }
}


//
//  VideoChatViewController.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import UIKit
import WebRTC
import PIPKit

class VideoChatViewController: UIViewController {

    var viewModel: VideoChatViewModel!
    
    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var speakerBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var hangupBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var caller: WebRTCView!
    var pipVC: PIPVideoVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        caller.videoView.vm = viewModel.videoVM
        
        pipVC = PIPVideoVC()
        pipVC.viewModel = viewModel.meVideoVM

        PIPKit.show(with: pipVC)
        
        recordBtn.layer.cornerRadius = 10
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.stopRecording()
        viewModel.uploadVideoToRender()
    }
    
    @IBAction func micPressed(_ sender: Any) {
        viewModel.toggleMic()
        
        micBtn.setImage(UIImage(named: viewModel.micOff ? "micOff" : "micOn"), for: .normal)
    }
    
    @IBAction func speakerPressed(_ sender: Any) {
        viewModel.toggleSpeaker()
        
        speakerBtn.setImage(UIImage(named: viewModel.speakerOff ? "soundOff" : "soundOn"), for: .normal)
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        viewModel.toggleCamera()
        
        cameraBtn.setImage(UIImage(named: viewModel.cameraOff ? "cameraOff" : "cameraOn"), for: .normal)
    }
    
    @IBAction func hangupPressed(_ sender: Any) {
        PIPKit.dismiss(animated: false)

        viewModel.hangUp()
    }
    
    @IBAction func recordPressed(_ sender: Any) {
        recordBtn.isEnabled = false
        
        viewModel.startRecording()
    }
}

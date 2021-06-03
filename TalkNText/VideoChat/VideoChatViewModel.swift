//
//  VideoChatViewModel.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import WebRTC
import Wyler
import Alamofire

protocol VideoChatViewModelCoordinatorDelegate: class {
    func didFinish()
}

final class VideoChatViewModel {
    var coordinatorDelegate: VideoChatViewModelCoordinatorDelegate!
    
    var webRTCClient: WebRTCClient!
    var videoVM: VideoVM!
    var meVideoVM: PIPVideoVM!
    var audioClient: AudioClient!
    var videoClient: VideoClient!
    
    var micOff: Bool = false
    var speakerOff: Bool = false
    var cameraOff: Bool = false
    
    var screenRecorder: ScreenRecorder!
    
    init(webRTCClient: WebRTCClient) {
        self.webRTCClient = webRTCClient
        videoVM = VideoVM(webRTCClient: webRTCClient, videoSource: .remote)
        
        meVideoVM = PIPVideoVM(webRTCClient: webRTCClient, videoSource: VideoSource(localVideoSource: .camera))
        
        audioClient = AudioClient(webRTCService: webRTCClient)
        
        videoClient = VideoClient(webRTCService: webRTCClient)
    }
    
    func toggleMic() {
        micOff ? self.audioClient.unmuteAudio() : self.audioClient.muteAudio()
        micOff = !micOff
    }
    
    func toggleSpeaker() {
        speakerOff ? self.audioClient.speakerOn() : self.audioClient.speakerOff()
        speakerOff = !speakerOff
    }
    
    func toggleCamera() {
        cameraOff ? self.videoClient.onVideo() : self.videoClient.offVideo()
        cameraOff = !cameraOff
    }
    
    func hangUp() {
        webRTCClient.hangup()
        self.coordinatorDelegate.didFinish()
        webRTCClient.startCall()
    }
}

extension VideoChatViewModel {
    func startRecording() {
        screenRecorder = ScreenRecorder()
        screenRecorder.startRecording { (error) in
            print(error)
        }
    }
    
    func stopRecording() {
        if screenRecorder != nil {
            self.screenRecorder.stoprecording(errorHandler: { error in
                debugPrint("Error when stop recording \(error)")
            })
        }
    }
    
    func uploadVideoToRender() {
        let directoryUrl = self.getDocumentsDirectory()
        let fileUrl = directoryUrl.appendingPathComponent("WylerNewVideo.mp4")
        
        self.uploadData(from: fileUrl)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func uploadData(from directoryUrl: URL) {
        let url = URL(string: "https://api-4u3e.onrender.com/")
        var request = URLRequest(url: url!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.timeoutInterval = 100

        let uuid = UUID().uuidString
        let fileName = "newmeeting\(uuid.suffix(4)).mp4"
        
        let manager = Alamofire.SessionManager.default
        manager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(directoryUrl, withName: "file", fileName: fileName, mimeType: "video/mp4")
                        
        }, with: request, encodingCompletion: { encodingResult in
            
            switch encodingResult {
            
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    switch response.result
                    {
                    case .success:
                        
                        let resultString = String(data: response.data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                        
                        print(resultString)
                        
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                    }
                    
                } case .failure(let error):
                    print(error)
            }
        })
    }
}

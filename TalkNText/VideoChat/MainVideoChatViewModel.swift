//
//  MainVideoChatViewModel.swift
//  TalkNText
//
//  Created by Julien Achkar on 21/04/2021.
//

import Foundation
import WebRTC

protocol MainVideoChatViewModelCoordinatorDelegate: class {
    func didStartCall(webRTCClient: WebRTCClient)
}

class MainVideoChatViewModel: WebRTCClientDelegate {
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("WebRTCClientDelegate didDiscoverLocalCandidate")
        
        let candidate = IceCandidate(from: candidate)
        
        signalingClient.collect(iceCandidate: candidate,
                                id: roomId,
                                name: isCreate ? "callerCandidates" : "calleeCandidates")
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
        print("WebRTCClientDelegate didChangeConnectionState ", state)
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        print("didReceiveData ", data)
    }
    
    var coordinatorDelegate: MainVideoChatViewModelCoordinatorDelegate!
    var roomId: String = ""
    var isCreate: Bool = false
    var webRTCClient: WebRTCClient!
    var signalingClient: SignalingClient!

    init() {
        webRTCClient = WebRTCClient(iceServers: Config.shared.iceServers)
        webRTCClient.delegate = self

        signalingClient = SignalingClient.shared
        
        setupDropDownCellsVM()
    }
    
    func create(id: String) {
        self.roomId = id
        saveRoomId(id: id)
        
        self.isCreate = true
        
        self.coordinatorDelegate.didStartCall(webRTCClient: self.webRTCClient)

        self.signalingClient.createRoom()
        
        self.webRTCClient.offer { rtcDescription in
            print("self.webRTCClient.offer")
            let descr = SessionDescription(from: rtcDescription)

            self.signalingClient.createOfferAndSubscribeForAnswer(desc: descr, id: id) { (sdp) in
                print("got answer sessionDescription ", sdp)
                
                self.signalingClient.getRemoteIceCandidates(id: id, name: "calleeCandidates") { (ices) in
                    let rtcCandiates = ices!.map {
                        $0.rtcIceCandidate
                    }
                    rtcCandiates.forEach {
                        self.webRTCClient.set(remoteCandidate: $0)
                    }
                }
                
                self.webRTCClient.set(remoteSdp: sdp.rtcSessionDescription) { error in
                    if let error = error {
                        print("createOfferAndSubscribe error set(remoteSdp: ", error)
                    }
                }
            }
        }
    }
    
    func join(id: String) {
        self.roomId = id
        self.isCreate = false
        saveRoomId(id: id)

        self.signalingClient.getRemoteIceCandidates(id: id, name: "calleeCandidates") { (ices) in
            let rtcCandiates = ices!.map {
                $0.rtcIceCandidate
            }
            rtcCandiates.forEach {
                self.webRTCClient.set(remoteCandidate: $0)
            }
            
            self.signalingClient.subscribeForRemoteOffer(roomId: id) { (sdp) in
                self.webRTCClient.set(remoteSdp: sdp.rtcSessionDescription) { (error) in
                    if let error = error {
                        print("createOfferAndSubscribe error set(remoteSdp: ", error)
                    }
                }
                
                self.webRTCClient.answer { (sessionDesc) in
                    self.signalingClient.createAnswer(desc: SessionDescription(from: sessionDesc), id: id)
                    
                    self.coordinatorDelegate.didStartCall(webRTCClient: self.webRTCClient)
                }
            }
        }
    }
    
    func saveRoomId(id: String) {
        var rooms = [String]()
        
        if let roomsIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] {
            rooms = roomsIds
        }
        
        if !rooms.contains(id) {
            rooms.append(id)
        }
        
        UserDefaults.standard.setValue(rooms, forKey: "roomIds")
        UserDefaults.standard.synchronize()
        
        setupDropDownCellsVM()
    }
    
    func setupDropDownCellsVM() {
        dropDownItems = []
        
        guard let roomIds = UserDefaults.standard.object(forKey: "roomIds") as? [String] else {
            return
        }
        
        for id in roomIds {
            dropDownItems.append(createDropDownViewModel(title: id))
        }
    }
    
    func createDropDownViewModel(title: String) -> SelectIDDropDownCellViewModel {
        return SelectIDDropDownCellViewModel(titleText: title)
    }
    
    var dropDownItems: [SelectIDDropDownCellViewModel] = []

    var dropDownTitles: [String] {
        return dropDownItems.map {$0.titleText}
    }
}

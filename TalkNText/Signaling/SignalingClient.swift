//
//  SignalClient.swift
//  WebRTC
//
//  Created by Zaporozhchenko Oleksandr on 4/25/20.
//  Copyright © 2020 maxatma. All rights reserved.
//

import WebRTC
import Firebase
import FirebaseFirestore

final class SignalingClient {
    static let shared = SignalingClient()
    
    //MARK: - CREATE
    
    typealias OfferCompletionHandler = (_ sessionDesc: SessionDescription) -> Void
    func createOfferAndSubscribeForAnswer(desc: SessionDescription?, id: String, completionHandler: @escaping OfferCompletionHandler) {
        let offer = desc.asDictionary()
        
        Firestore.firestore()
            .collection("rooms")
            .document(id)
            .setData(["offer": offer],
                     completion: { error in
                        if let error = error {
                            print("error is ", error)
                            return
                            
                        }
                        
                        self.subscribeForAns(id: id) { (sdp) in
                            completionHandler(sdp)
                        }
                     })
    }
    
    
    typealias AnswerCompletionHandler = (_ sessionDesc: SessionDescription) -> Void
    private func subscribeForAns(id: String, completionHandler: @escaping AnswerCompletionHandler) {
        var sessionDesc: SessionDescription?
        
        Firestore.firestore()
            .collection("rooms")
            .document(id)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("error is ", error)
                    // observer.failed(error as! NSError)
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    print("no snapshot ")
                    return
                }
                
                guard let answer = snapshot.get("answer") as? [String: String] else {
                    print("no answer ")
                    return
                }
                
                guard let sdp = answer["sdp"] else {
                    print("no sdp in answer" )
                    return
                }
                
                sessionDesc = SessionDescription(from: RTCSessionDescription(type: .answer, sdp: sdp))
                completionHandler(sessionDesc!)
            }
    }
    
    func createRoom() {
        Firestore.firestore()
            .collection("rooms")
            .addDocument(data: [:])
    }
    
    //MARK: - JOIN
    
    func createAnswer(desc: SessionDescription?, id: String) {
        let answer = desc.asDictionary()
        
        Firestore.firestore()
            .collection("rooms")
            .document(id)
            .setData(["answer": answer])
    }
    
    
    typealias RemoteOfferCompletionHandler = (_ sessionDesc: SessionDescription) -> Void
    func subscribeForRemoteOffer(roomId: String, completionHandler: @escaping RemoteOfferCompletionHandler) {
        var sessionDesc: SessionDescription?
        
        Firestore.firestore()
            .collection("rooms")
            .document(roomId)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("error is ", error)
                    // observer.failed(error as! NSError)
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    print("no snapshot ")
                    return
                }
                
                guard let remoteOffer = snapshot.data()?["offer"] as? [String: Any] else {
                    print("no offer ")
                    return
                }
                
                guard let sdp = remoteOffer["sdp"] as? String else {
                    print("no sdp in offer" )
                    return
                }
                
                sessionDesc = SessionDescription(from: RTCSessionDescription(type: .offer, sdp: sdp))
                completionHandler(sessionDesc!)
            }
        
        
    }
    
    //MARK: - Candidates
    
    func collect(iceCandidate: IceCandidate?, id: String, name: String) {
        
        guard let iceCandidate = iceCandidate else {
            return
        }
        
        let ice = [
            "candidate": iceCandidate.sdp,
            "sdpMLineIndex": iceCandidate.sdpMLineIndex,
            "sdpMid": iceCandidate.sdpMid ?? "0"
        ] as [String : Any]
        
        Firestore.firestore()
            .collection("rooms")
            .document(id)
            .collection(name)
            .addDocument(data: ice)
    }
    
    typealias RemoteICECompletionHandler = (_ ices: [IceCandidate]?) -> Void
    func getRemoteIceCandidates(id: String, name: String, completionHandler: @escaping RemoteICECompletionHandler) {
        var iceCandidates: [IceCandidate]?
        
        Firestore.firestore()
            .collection("rooms")
            .document(id)
            .collection(name)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("error ", error)
                    return
                }
                
                let dataChanges = snapshot!.documentChanges.filter { $0.type == .added }
                
                iceCandidates = dataChanges
                    .map { change -> IceCandidate in
                        let data = change.document.data()
                        
                        return IceCandidate(from:
                                                RTCIceCandidate(sdp: data["candidate"] as! String,
                                                                sdpMLineIndex: data["sdpMLineIndex"] as! Int32,
                                                                sdpMid: data["sdpMid"] as? String))
                    }
                completionHandler(iceCandidates)
                
            }
        
    }
}


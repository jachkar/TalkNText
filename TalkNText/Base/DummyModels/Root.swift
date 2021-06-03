//
//  Root.swift
//
//
//  -- auto-generated by JSON2Swift --
//

import Foundation


struct Root: JSONCompatible {
    var roomcall: [RoomCall]
    var roomchat: [RoomChat]

    init?(json: [String: Any]?) {
        guard let json = json else {return nil}
        roomcall = (json["roomcall"] as? [[String: Any]] ?? []).flatMap{RoomCall(json: $0)}
        roomchat = (json["roomchat"] as? [[String: Any]] ?? []).flatMap{RoomChat(json: $0)}
    }



    init() {
        self.init(json: [:])!
    }



    init?(data: Data?) {
        guard let data = data else {return nil}
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {return nil}
        self.init(json: json)
    }



    init(roomcall: [RoomCall], roomchat: [RoomChat]) {
        self.roomcall = roomcall
        self.roomchat = roomchat
    }



    func jsonDictionary(useOriginalJsonKey: Bool) -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["roomchat"] = roomchat.map{$0.jsonDictionary(useOriginalJsonKey: useOriginalJsonKey)}
        dict["roomcall"] = roomcall.map{$0.jsonDictionary(useOriginalJsonKey: useOriginalJsonKey)}
        return dict
    }



}



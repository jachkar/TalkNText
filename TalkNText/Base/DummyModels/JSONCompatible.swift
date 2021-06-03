//
//  JSONCompatible.swift
//  Zong
//
//  Created by Julien Achkar on 01/12/2020.
//

import Foundation

protocol JSONCompatible {
    init?(json: [String: Any]?)
    init()
    init?(data: Data?)
    func jsonDictionary(useOriginalJsonKey: Bool) -> [String: Any]
}

//
//  LineEntity.swift
//  Chomp
//
//  Created by Sky Welch on 11/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LineEntity: JsonDecodable {
    let id: Int
    let nick: String
    let buffer: Int
    let user: Int?
    let kind: String
    let content: String
    let timestamp: Float

    static func decode(json: JSON) -> LineEntity? {
        if let id = json["id"].int,
            let nick = json["nick"].string,
            let buffer = json["buffer"].int,
            let kind = json["kind"].string,
            let content = json["content"].string,
            let timestamp = json["timestamp"].float {
            return LineEntity(id: id, nick: nick, buffer: buffer, user: json["user"].int, kind: kind, content: content, timestamp: timestamp)
        }

        return nil
    }
}
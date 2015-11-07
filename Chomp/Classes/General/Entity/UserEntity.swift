//
//  User.swift
//  Chomp
//
//  Created by Sky Welch on 07/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserEntity: JsonDecodable {
    let id: Int
    let nick: String
    let username: String?
    let host: String?
    let server: Int
    let realname: String?
    let current: Bool

    static func decode(json: JSON) -> UserEntity? {
        if let id = json["id"].int,
            let nick = json["nick"].string,
            let server = json["server"].int,
            let current = json["current"].bool {
            return UserEntity(id: id, nick: nick, username: json["username"].string, host: json["host"].string, server: server, realname: json["realname"].string, current: current)
        }

        return nil
    }
}
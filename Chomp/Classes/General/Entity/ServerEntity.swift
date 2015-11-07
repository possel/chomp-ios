//
//  ServerEntity.swift
//  Chomp
//
//  Created by Sky Welch on 04/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ServerEntity: JsonDecodable {
    let user: Int
    let id: Int
    let secure: Bool
    let port: Int
    let host: String

    static func decode(json: JSON) -> ServerEntity? {
        if let user = json["user"].int,
            let id = json["id"].int,
            let secure = json["secure"].bool,
            let port = json["port"].int,
            let host = json["host"].string {
            return ServerEntity(user: user, id: id, secure: secure, port: port, host: host)
        }

        return nil
    }
}
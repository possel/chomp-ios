//
//  BufferEntity.swift
//  Chomp
//
//  Created by Sky Welch on 07/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BufferEntity: JsonDecodable {
    let id: Int
    let current: Bool
    let name: String
    let server: Int?
    let kind: String

    static func decode(json: JSON) -> BufferEntity? {
        if let id = json["id"].int,
            let current = json["current"].bool,
            let name = json["name"].string,
            let kind = json["kind"].string {
            return BufferEntity(id: id, current: current, name: name, server: json["server"].int, kind: kind)
        }

        return nil
    }
}
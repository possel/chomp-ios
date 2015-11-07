//
// Created by Sky Welch on 06/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonTypedArray {
    class func decodeTypedArray<T: JsonDecodable>(json: JSON) -> [T]? {
        var array: [T] = []

        for (_, subJson) in json {
            if let subItem = T.decode(subJson) {
                array.append(subItem)
            } else {
                return nil
            }
        }

        return array
    }
}

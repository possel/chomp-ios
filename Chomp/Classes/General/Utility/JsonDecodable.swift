//
// Created by Sky Welch on 06/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JsonDecodable {
    static func decode(json: JSON) -> Self?
}

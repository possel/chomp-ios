//
//  ChompWebsocketListener.swift
//  Chomp
//
//  Created by Sky Welch on 11/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol ChompWebsocketListener: class {
    func onReceivedLineForBuffer(id: Int, line: LineEntity)
}

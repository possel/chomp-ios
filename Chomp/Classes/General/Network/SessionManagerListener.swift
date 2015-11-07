//
//  SessionManagerListener.swift
//  Chomp
//
//  Created by Sky Welch on 05/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol SessionManagerListener: class {
    func onNewSession()
    
    func onSessionInvalidated()
}
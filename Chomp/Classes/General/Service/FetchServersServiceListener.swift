//
//  FetchServersInteractorDelegate.swift
//  Chomp
//
//  Created by Sky Welch on 03/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol FetchServersServiceListener: class {
    func onFetchServersCompleted(servers: [ServerEntity])
    
    func onFetchServersFailed()
}
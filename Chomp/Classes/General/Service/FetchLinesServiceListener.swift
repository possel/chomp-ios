//
//  FetchLinesServiceListener.swift
//  Chomp
//
//  Created by Sky Welch on 11/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol FetchLinesServiceListener: class {
    func onFetchLinesCompleted(buffer: Int, lines: [LineEntity])
    
    func onFetchLinesFailed()
}
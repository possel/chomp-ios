//
//  OverviewView.swift
//  Chomp
//
//  Created by Sky Welch on 04/10/2015.
//  Copyright © 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol OverviewView {    
    func showFetchServersFailure()
    func showFetchBuffersFailure()
    func showFetchUserFailure()
    
    func pushBufferView(buffer: BufferEntity)
}
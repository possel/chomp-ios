//
// Created by Sky Welch on 06/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation

protocol AuthManagerListener: class {
    func onAuthSucceeded()

    func onAuthFailed()
}

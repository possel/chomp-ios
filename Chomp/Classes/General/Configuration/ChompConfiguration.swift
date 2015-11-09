//
// Created by Sky Welch on 09/11/2015.
// Copyright (c) 2015 Sky Welch. All rights reserved.
//

import Foundation

class ChompConfiguration {
    private static let apiDomainKey = "apiDomain"
    private static let defaultApiDomain = "127.0.0.1"

    private static let apiPortKey = "apiPort"
    private static let defaultApiPort = "8080"

    private static let apiUserKey = "apiUser"
    private static let defaultApiUser = ""

    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastLauched = defaults.stringForKey("lastLaunched")
    }

    var apiDomain: String {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(ChompConfiguration.apiDomainKey) ?? ChompConfiguration.defaultApiDomain
        }

        set(newApiDomain) {
            NSUserDefaults.standardUserDefaults().setObject(newApiDomain, forKey: ChompConfiguration.apiDomainKey)
        }
    }

    var apiUser: String {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(ChompConfiguration.apiUserKey) ?? ChompConfiguration.defaultApiUser
        }

        set(newApiUser) {
            NSUserDefaults.standardUserDefaults().setObject(newApiUser, forKey: ChompConfiguration.apiUserKey)
        }
    }

    var apiPort: String {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(ChompConfiguration.apiPortKey) ?? ChompConfiguration.defaultApiPort
        }

        set (newApiPort) {
            NSUserDefaults.standardUserDefaults().setObject(newApiPort, forKey: ChompConfiguration.apiPortKey)
        }
    }
}
